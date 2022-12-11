import 'Model/track.dart';
import 'helper.dart';

class Settings{
static bool darkTheme = false;  // темная тема
static bool exclusive = false; // режим эксклюзив
static double vol = 0.5; // дефолтное значение звука
static bool vstEq = true; // включен ли вст эквалайзер
static bool isFX = false; // включен или выключен эквалайзер.
static bool yandexD = false; // яндекс диск подключен или нет
static bool position = true; // главный слайдер трека
static double pos = 0; // дефолтное значение главного слайдера трека
static bool loop = false; // зацикливание трека
static bool mute = false; // режим без звука
static int songCount = 0; // какая песня выбрана
static int listCount = 1; // какой плейлист выбран
static bool shuffle = false; // случайный трек
static List<Track> favorite = []; // плелист любимых песен
static List<Track> search = [];
static List<String> listOfCovers = ['','']; 
static List<bool> selectedList = [false,true];
static List<List<Track>> data = [search,[]]; //список всех плейлистов
static bool showSearch = false;  // показываем поиск или нет
static PlayerOptions options = PlayerOptions.standart; // состояние плеера
static bool twin = false; //не выводим повторы в поиске
static List<bool> playlistPic = [false,false]; // есть ли у плейлиста в листе картинка
static bool songChangedbyButton = false; // отслеживаем состояние - пользователь нажал на кнопку и песня поменялась или трек подошел к концу и песня сменилась.
}