FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/wotakumoe/Wotaku.git && \
    cd Wotaku && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG})
    # rm -rf .git

FROM --platform=$BUILDPLATFORM node AS build

WORKDIR /Wotaku
COPY --from=base /git/Wotaku .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm docs:build

FROM joseluisq/static-web-server

COPY --from=build /Wotaku/docs/.vitepress/dist ./public
