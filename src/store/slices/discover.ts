import { TMDB_V3_API_KEY } from "src/constant";
import { tmdbApi } from "./apiSlice";
import { MEDIA_TYPE, PaginatedMovieResult } from "src/types/Common";
import { MovieDetail } from "src/types/Movie";
import { createSlice, isAnyOf, PayloadAction } from "@reduxjs/toolkit";
import type { Movie } from "src/types/Movie";

// Define proper types for actions
interface SetNextPageAction {
  mediaType: string;
  itemKey: string | number;
}

interface InitiateItemAction {
  mediaType: string;
  itemKey: string | number;
}

interface FulfilledAction {
  page: number;
  results: Movie[];
  total_pages: number;
  total_results: number;
  mediaType: string;
  itemKey: string | number;
}

const initialState: Record<string, Record<string, PaginatedMovieResult>> = {};
export const initialItemState: PaginatedMovieResult = {
  page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
};

const discoverSlice = createSlice({
  name: "discover",
  initialState,
  reducers: {
    setNextPage: (state, action: PayloadAction<SetNextPageAction>) => {
      const { mediaType, itemKey } = action.payload;
      state[mediaType][itemKey].page += 1;
    },
    initiateItem: (state, action: PayloadAction<InitiateItemAction>) => {
      const { mediaType, itemKey } = action.payload;
      if (!state[mediaType]) {
        state[mediaType] = {};
      }
      if (!state[mediaType][itemKey]) {
        state[mediaType][itemKey] = { ...initialItemState };
      }
    },
  },
  extraReducers: (builder) => {
    builder.addMatcher(
      isAnyOf(
        extendedApi.endpoints.getVideosByMediaTypeAndCustomGenre.matchFulfilled,
        extendedApi.endpoints.getVideosByMediaTypeAndGenreId.matchFulfilled
      ),
      (state, action: PayloadAction<FulfilledAction>) => {
        const {
          page,
          results,
          total_pages,
          total_results,
          mediaType,
          itemKey,
        } = action.payload;
        state[mediaType][itemKey].page = page;
        
        // Get existing movie IDs to prevent duplicates
        const existingIds = new Set(state[mediaType][itemKey].results.map((movie: Movie) => movie.id));
        
        // Filter out movies that already exist
        const newResults = results.filter((movie: Movie) => !existingIds.has(movie.id));
        
        // Only add new unique movies
        state[mediaType][itemKey].results.push(...newResults);
        state[mediaType][itemKey].total_pages = total_pages;
        state[mediaType][itemKey].total_results = total_results;
      }
    );
  },
});

export const { setNextPage, initiateItem } = discoverSlice.actions;
export default discoverSlice.reducer;

const extendedApi = tmdbApi.injectEndpoints({
  endpoints: (build) => ({
    getVideosByMediaTypeAndGenreId: build.query<
      PaginatedMovieResult & {
        mediaType: MEDIA_TYPE;
        itemKey: number | string;
      },
      { mediaType: MEDIA_TYPE; genreId: number; page: number }
    >({
      query: ({ mediaType, genreId, page }) => ({
        url: `/discover/${mediaType}`,
        params: { api_key: TMDB_V3_API_KEY, with_genres: genreId, page },
      }),
      transformResponse: (
        response: PaginatedMovieResult,
        _,
        { mediaType, genreId }
      ) => ({
        ...response,
        mediaType,
        itemKey: genreId,
      }),
    }),
    getVideosByMediaTypeAndCustomGenre: build.query<
      PaginatedMovieResult & {
        mediaType: MEDIA_TYPE;
        itemKey: number | string;
      },
      { mediaType: MEDIA_TYPE; apiString: string; page: number }
    >({
      query: ({ mediaType, apiString, page }) => ({
        url: `/${mediaType}/${apiString}`,
        params: { api_key: TMDB_V3_API_KEY, page },
      }),
      transformResponse: (
        response: PaginatedMovieResult,
        _,
        { mediaType, apiString }
      ) => {
        return {
          ...response,
          mediaType,
          itemKey: apiString,
        };
      },
    }),
    getAppendedVideos: build.query<
      MovieDetail,
      { mediaType: MEDIA_TYPE; id: number }
    >({
      query: ({ mediaType, id }) => ({
        url: `/${mediaType}/${id}`,
        params: { api_key: TMDB_V3_API_KEY, append_to_response: "videos" },
      }),
    }),
    getSimilarVideos: build.query<
      PaginatedMovieResult,
      { mediaType: MEDIA_TYPE; id: number }
    >({
      query: ({ mediaType, id }) => ({
        url: `/${mediaType}/${id}/similar`,
        params: { api_key: TMDB_V3_API_KEY },
      }),
    }),
  }),
});

export const {
  useGetVideosByMediaTypeAndGenreIdQuery,
  useLazyGetVideosByMediaTypeAndGenreIdQuery,
  useGetVideosByMediaTypeAndCustomGenreQuery,
  useLazyGetVideosByMediaTypeAndCustomGenreQuery,
  useGetAppendedVideosQuery,
  useLazyGetAppendedVideosQuery,
  useGetSimilarVideosQuery,
  useLazyGetSimilarVideosQuery,
} = extendedApi;
