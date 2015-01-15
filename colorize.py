#!/usr/bin/env python
#
# Colorizes a FigTree file according to a species colormap. See USAGE below.
# Written by William Ehlhardt

import doctest
import re
import sys

USAGE="""python colorize.py COLORMAP input1.tree input2.tree ...

Will create input1_colorized.tree, input2_colorized.tree, etc.
"""

COLORMAP_FORMAT = """The COLORMAP file looks like this:

SpeciesId1 #ff00ff
SpeciesId2 #f00dee

SpeciesIds are arbitrary strings.
The colors are standard HTML hexadecimal.
"""

def load_species_colormap(filename):
    f = open(filename)
    colormap = {}
    for line in f:
        # Strip off whitespace
        line = line.strip()
        # Parse the line
        line = line.split()
        if len(line) != 2:
            raise Exception('Unable to parse line in color map: ', line)

        species, color = line
        colormap[species] = color

    return colormap


GENEIDS_LOCATE_TEST_INPUT="""
        'Orysa5|Os06g41910'
        'Orysa5|Os06g22330'
        'Sorbi1|Sb10g013010.1'
        'Sorbi1|Sb04g030080.1'
        'Orysa5|Os02g48190'
        'Arath7|AT2G33570'
"""

def locate_geneids(treefile, species):
    """Find the geneids in the file, starting with a species list.

    >>> locate_geneids(GENEIDS_LOCATE_TEST_INPUT, 'Orysa')
    ['Orysa5|Os02g48190', 'Orysa5|Os06g22330', 'Orysa5|Os06g41910']
    >>> locate_geneids(GENEIDS_LOCATE_TEST_INPUT, 'Sorbi')
    ['Sorbi1|Sb04g030080.1', 'Sorbi1|Sb10g013010.1']
    >>> locate_geneids(GENEIDS_LOCATE_TEST_INPUT, 'Arath')
    ['Arath7|AT2G33570']
    """

    geneids = []
    r = re.compile(r"%s[^']*\|[^']*" % species)
    geneids.extend(r.findall(treefile))
    return sorted(set(geneids))

def process_treefile(treefile, colormap, outfile):
    # All right, guys. We're totally going to parse this file. And by
    # parse, I mean "parse".
    f = open(treefile)

    # Zip on down the file until we find the "begin trees" line.
    while True:
        line = f.readline()
        # Re-emit the line unchanged.
        outfile.write(line)
        # OK, there it is! Stop fastforwarding!
        if line.lower().startswith("begin trees;"):
            break

    # The next line is, hooopefully, the actual tree description.
    treeline = f.readline().strip()
    # Let's check if it is!
    if not treeline.lower().startswith('tree'):
        raise Exception(
            "The line after 'begin trees;' was not a tree line.")
    
    # OK! Great! Do a bunch of string-replace! (This is the real meat
    # of this program. The rest is basically window-dressing.)

    # Helper function to generate the actual string we're looking for
    # in the tree line.
    def fromstr(geneid):
        return "'%s'" % geneid

    # Helper function to generate the geneid + color-clause string.
    def tostr(geneid, color):
        return fromstr(geneid) + '[&!color=' + color + ']'

    # Go through and stick the color-clause after each of the gene ids.
    for geneid, color in colormap.items():
        treeline = treeline.replace(fromstr(geneid),
                                    tostr(geneid, color))
    
    # OK, now re-emit the treeline
    outfile.write(treeline)
    
    # And print out the rest of the file
    outfile.write(f.read())


if not doctest.testmod():
    print >> sys.stderr, "Internal tests failed. Aborting."
    sys.exit(-10)


if len(sys.argv) < 3:
    print >> sys.stderr, USAGE
    sys.exit(1)

colormap_file = sys.argv[1]
tree_files = sys.argv[2:]

try:
    species_colormap = load_species_colormap(colormap_file)
except:
    print >> sys.stderr, "Failed to parse the color map!"
    print >> sys.stdarr, COLORMAP_FORMAT

for tree_file in tree_files:
    gene_colormap = {}
    for species, color in species_colormap.items():
        geneids = locate_geneids(open(tree_file).read(), species)
        if len(geneids) == 0:
            print >> sys.stderr, (
                "WARNING: Failed to find any gene ids for species %s in %s"
                % (species, tree_file))
        for gene in geneids:
            gene_colormap[gene] = color

    # Create the tree output filename.
    base, ext = tree_file.rsplit('.', 1)
    output_filename = base + '_colorized.' + ext
    process_treefile(tree_file, gene_colormap, open(output_filename, 'w'))

