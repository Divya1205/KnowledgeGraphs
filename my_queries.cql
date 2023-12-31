// my_queries.cql

// Create a 'Compound' node with properties 'pdid' and 'name'
// This command assumes you've loaded a CSV where each row represents a compound
LOAD CSV WITH HEADERS FROM 'file:///pd_export_04_2022_2464_targets_standardized.csv' AS row
MERGE (c:Compound {pdid: row.pdid, name: row.name});

//to use with names of compounds
//LOAD CSV WITH HEADERS FROM 'file:///pd_export_04_2022_2464_targets_standardized.csv' AS row
//MERGE (c:Compound {name: row.name});


// Create 'Gene' nodes based on the 'gene_name' property from the CSV
// If a compound is related to multiple genes (gene names separated by commas),
// this command will split them and create separate 'Gene' nodes for each one
LOAD CSV WITH HEADERS FROM 'file:///pd_export_04_2022_2464_targets_standardized.csv' AS row
UNWIND split(row.gene_name, ",") AS gene
MERGE (g:Gene {name: gene});

// Create relationships between 'Compound' nodes and 'Gene' nodes
// The 'INTERACTS_WITH' relationship indicates that a compound interacts with a gene
LOAD CSV WITH HEADERS FROM 'file:///pd_export_04_2022_2464_targets_standardized.csv' AS row
UNWIND split(row.gene_name, ",") AS gene
MATCH (c:Compound {pdid: row.pdid}), (g:Gene {name: gene})
MERGE (c)-[:INTERACTS_WITH]->(g);

// if you use compound names instead of pdid
//LOAD CSV WITH HEADERS FROM 'file:///pd_export_04_2022_2464_targets_standardized.csv' AS row
//UNWIND split(row.gene_name, ",") AS gene
//MATCH (c:Compound {name: row.name}), (g:Gene {name: gene})
//MERGE (c)-[:INTERACTS_WITH]->(g);

// Query to visualize the created nodes and relationships
// Fetches all 'Compound' nodes, their relationships, and the connected 'Gene' nodes
MATCH (c:Compound)-[r:INTERACTS_WITH]->(g:Gene)
RETURN c, r, g LIMIT 100;

// Limiting the results to the first 100 for visualization purposes

//remove all nodes
//MATCH (n)
//DETACH DELETE n
