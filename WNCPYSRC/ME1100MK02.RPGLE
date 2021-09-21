      *****************************************************************
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 MKFX01             Date 23Jan06               *
      *                 PNL002  *Create    Date 22Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  MKFX01 - Processing of field :24: added.                     *
      *  PNL002 - Changes to MultiCash interface.                     *
      *                                                               *
      *****************************************************************
      *
     C     PRMDS         WHENEQ    'P32A'                                                     PNL002
     C     CRMTPY        IFEQ      '100'                                                      PNL002
     C     CRNWRK        ANDEQ     'MTCASH'                                                   PNL002
     C     SVTAG         ANDEQ     ':32A:'                                                    PNL002
     C                   MOVEL     DSTRAN        DSIN                                         PNL002
     C                   MOVEL     *BLANK        DSOUT                                        PNL002
     C                   MOVEL     P32A          DSOUT                                        PNL002
     C                   EXSR      SRFILL                                                     PNL002
     C                   MOVEL     DSOUT         P32A                                         PNL002
     C     MPSVDT        IFNE      *BLANKS                                                    PNL002
     C                   MOVEL     MPSVDT        TVVDAT                                       PNL002
     C                   ELSE                                                                 PNL002
     C                   MOVEL     CRSVDT        TVVDAT                                       PNL002
     C                   END                                                                  PNL002
     C                   ENDIF                                                                PNL002
     C     MPAMTS        IFNE      *BLANKS                                                    PNL002
     C                   MOVEL     MPAMTS        TVAMT1           16                          PNL002
     C                   ELSE                                                                 PNL002
     C                   MOVEL     CRAMTS        TVAMT1           16                          PNL002
     C                   END                                                                  PNL002
     C                   MOVEA     TVAMT1        TVAA                                         PNL002
     C     TVAA(1)       IFEQ      '0'                                                        PNL002
     C     TVAA(2)       ANDNE     ','                                                        PNL002
     C                   MOVE      TVAMT1        TVAMT                                        PNL002
     C                   ELSE                                                                 PNL002
     C                   MOVEL     TVAMT1        TVAMT                                        PNL002
     C                   END                                                                  PNL002
     C     MPCYCD        IFNE      *BLANKS                                                    PNL002
     C                   MOVEL     MPCYCD        TVCCY                                        PNL002
     C                   ELSE                                                                 PNL002
     C                   MOVEL     CRCYCD        TVCCY                                        PNL002
     C                   END                                                                  PNL002
     C                   MOVEL     DSTRAN        PDCA                                         PNL002
      *                                                                                       PNL002
     C     PRMDS         WHENEQ    'P36C'                                                     PNL002
     C                   MOVEL     DSTRAN        DSIN                                         PNL002
     C                   MOVEL     *BLANK        DSOUT                                        PNL002
     C                   MOVEL     P36C          DSOUT                                        PNL002
     C                   EXSR      SRFILL                                                     PNL002
     C                   MOVEL     DSOUT         P36C                                         PNL002
      *                                                                                       PNL002
     C     PRMDS         WHENEQ    'P51'                                                      PNL002
     C                   MOVEL     DSTRAN        DSIN                                         PNL002
     C                   MOVEL     *BLANK        DSOUT                                        PNL002
     C                   MOVEL     P51           DSOUT                                        PNL002
     C                   EXSR      SRFILL                                                     PNL002
     C                   MOVEL     DSOUT         P51                                          PNL002
      *                                                                                       PNL002
     C     PRMDS         WHENEQ    'P73'                                                      PNL002
     C                   MOVEL     DSTRAN        DSIN                                         PNL002
     C                   MOVEL     *BLANK        DSOUT                                        PNL002
     C                   MOVEL     P73           DSOUT                                        PNL002
     C                   EXSR      SRFILL                                                     PNL002
     C                   MOVEL     DSOUT         P73                                          PNL002
      *                                                                                       PNL002
     C     PRMDS         WHENEQ    'P80'                                                      PNL002
     C                   MOVEL     DSTRAN        DSIN                                         PNL002
     C                   MOVEL     *BLANK        DSOUT                                        PNL002
     C                   MOVEL     P80           DSOUT                                        PNL002
     C                   EXSR      SRFILL                                                     PNL002
     C                   MOVEL     DSOUT         P80                                          PNL002
      *                                                                                       PNL002
     C     PRMDS         WHENEQ    'P24'                                                      MKFX01
     C                   MOVEL     DSTRAN        DSIN                                         MKFX01
     C                   MOVEL     *BLANK        DSOUT                                        MKFX01
     C                   MOVEL     P24           DSOUT                                        MKFX01
     C                   EXSR      SRFILL                                                     MKFX01
     C                   MOVEL     DSOUT         P24                                          MKFX01
      *                                                                                       MKFX01
      *
      * End of /COPY ME1100MK02                                       *
      *****************************************************************
