part of 'ai_assistant_bloc.dart';

sealed class AiAssistantEvent extends Equatable {
  const AiAssistantEvent();

  @override
  List<Object> get props => [];
}

class AddIngredientEvent extends AiAssistantEvent {
  final String ingredient;
  
  const AddIngredientEvent(this.ingredient);
  
  @override
  List<Object> get props => [ingredient];
}

class RemoveIngredientEvent extends AiAssistantEvent {
  final int index;
  
  const RemoveIngredientEvent(this.index);
  
  @override
  List<Object> get props => [index];
}

class GetRecipeSuggestionsEvent extends AiAssistantEvent {
  final List<String> ingredients;
  
  const GetRecipeSuggestionsEvent(this.ingredients);
  
  @override
  List<Object> get props => [ingredients];
}

class ClearRecipesEvent extends AiAssistantEvent {}
