module BLOB
  class Ontology < ::Ontology
    include Singleton

    def initialize
      super('a.owl', BLOB::Term)
    end

    def all_topics
      #puts "blob ontology"
      #puts(OBO.inSubset)
      #puts(OBO.to_s)
      #find_by(OBO.subClassOf, OBO_BLOB.topics)     
      find_by(OBO.inSubset, OBO_BLOB.topics)
    end

    def all_operations
      find_by(OBO.inSubset, OBO_BLOB.operations)
    end

    def lookup_by_name(name)
      lookup_by(RDF::RDFS.label, name)
    end

    def scoped_lookup_by_name(name, subset = :_)
      query = RDF::Query.new do
        pattern [:u, RDF::RDFS.label, name]
        pattern [:u, OBO.inSubset, subset]
      end

      result = graph.query(query).first
      lookup(result.u) if result
    end
  end
end
