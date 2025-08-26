part of 'ai_assistant_bloc.dart';

sealed class AiAssistantState extends Equatable {
  const AiAssistantState();

  @override
  List<Object> get props => [];
}

final class AiAssistantInitial extends AiAssistantState {
  final List<String> ingredients;
  
  const AiAssistantInitial({this.ingredients = const []});
  
  @override
  List<Object> get props => [ingredients];
}

final class AiAssistantLoading extends AiAssistantState {
  final List<String> ingredients;
  
  const AiAssistantLoading(this.ingredients);
  
  @override
  List<Object> get props => [ingredients];
}

final class AiAssistantLoaded extends AiAssistantState {
  final List<String> ingredients;
  final List<Recipe> recipes;
  
  const AiAssistantLoaded({
    required this.ingredients,
    required this.recipes,
  });
  
  @override
  List<Object> get props => [ingredients, recipes];
}

final class AiAssistantError extends AiAssistantState {
  final List<String> ingredients;
  final String message;
  
  const AiAssistantError({
    required this.ingredients,
    required this.message,
  });
  
  @override
  List<Object> get props => [ingredients, message];
}
