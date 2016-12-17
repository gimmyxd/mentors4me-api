module BaseResource
  include Apipie::DSL::Concern

  def doc_for(action_name, &block)
    instance_eval(&block)
    define_method(action_name) do
    end
  end
end
