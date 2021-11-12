class OntologyTermLink < ApplicationRecord
  belongs_to :resource, polymorphic: true

  def ontology_term
    ontology.lookup(term_uri)
  end

  def ontology
    #EDAM::Ontology.instance
    #puts "ontology term link"
    BLOB::Ontology.instance
  end
end
