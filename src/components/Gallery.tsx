import { useState, type ReactElement, Fragment } from 'react';
import ReactSimplyCarousel from 'react-simply-carousel';

interface Image {
    title: string,
    source: string,
};

interface GalleryProps {
    data: Array<Image>
};

type GalleryType = (T: GalleryProps) => ReactElement;

const Gallery: GalleryType = (props: GalleryProps) => {
     const [activeSlideIndex, setActiveSlideIndex] = useState(0);
    const {data} = props;
    return <Fragment>
        <ReactSimplyCarousel
            activeSlideIndex={activeSlideIndex}
            onRequestChange={setActiveSlideIndex}
            itemsToShow={1}
            itemsToScroll={1}
            forwardBtnProps={{
          //here you can also pass className, or any other button element attributes
          style: {
            alignSelf: 'center',
            background: 'black',
            border: 'none',
            borderRadius: '50%',
            color: 'white',
            cursor: 'pointer',
            fontSize: '20px',
            height: 30,
            lineHeight: 1,
            textAlign: 'center',
            width: 30,
          },
          children: <span>{`>`}</span>,
        }}
        backwardBtnProps={{
          //here you can also pass className, or any other button element attributes
          style: {
            alignSelf: 'center',
            background: 'black',
            border: 'none',
            borderRadius: '50%',
            color: 'white',
            cursor: 'pointer',
            fontSize: '20px',
            height: 30,
            lineHeight: 1,
            textAlign: 'center',
            width: 30,
          },
          children: <span>{`<`}</span>,
        }}
        speed={400}
        autoplay={true}
        disableNavIfEdgeVisible={false}
        >
            {data.map((p, i) => <img key={i} src={p.source}  alt={p.title} />)}
        </ReactSimplyCarousel>
    </Fragment>
};

export default Gallery;