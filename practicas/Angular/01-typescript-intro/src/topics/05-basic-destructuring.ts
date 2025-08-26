

interface AudioPlayer {
    audioVolumen: number;
    songDuration: number;
    song: string;
    details: Details;
}

interface Details {
    author: string;
    year: number;
}

const audioPlayer: AudioPlayer = {
    audioVolumen: 90,
    songDuration: 36,
    song: "Mess",
    details: {
        author: 'Ed sheeran',
        year: 2015
    } 
}


const { 
    song,
    songDuration:Duration,
    details
} = audioPlayer;

const { author } = details;

// console.log('song:', song);
// console.log('Duration', Duration);
// console.log('Author:', author);


const [, , , trunks = 'nop hay']: string[] =['goku', 'vegeta', 'trunks' ];

console.error('personajes 3:', trunks);