     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MX Element Enquiry')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT020023DP - MX Element Data Enquiry                         *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059739           Date 23Mar22               *
      *  Prev Amend No. CSW122  *CREATE    Date 04Oct21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059739 - Use only the UETR field to link MX and FT         *
      *             transaction                                       *
      *  CSW122 - SWIFT ISO 20022                                     *
      *                                                               *
      *****************************************************************
      *
     FFT020023DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     SFILE(FT020023S0:S0RRN)
     F***MEISOML1  IF   E           K DISK    INFSR(*PSSR)                                  MD059739
     FMEISOML2  IF   E           K DISK    INFSR(*PSSR)                                     MD059739
     FMEDESCL1  IF   E           K DISK    INFSR(*PSSR)
     FMEISODL1  IF   E           K DISK    INFSR(*PSSR)
     FMEINDTL0  IF   E           K DISK    INFSR(*PSSR)
     FMEIN35L0  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   KC - F3  Exit                                               *
      *   KL - F12 Previous                                           *
      *                                                               *
      *   30 - S0 SFLDSPCTL                                           *
      *   31 - S0 SFLDSP                                              *
      *   32 - S0 SFLEND                                              *
      *   33 - S0 SFLNXTCHG                                           *
      *   39 - S0 ROLLUP                                              *
      *                                                               *
      *****************************************************************
      *
      ** File Information Data structure for Display file
      *
     D INFDS1          DS
     D  INSFRC               378    379B 0
      *
      ** Program status data structure
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Data Structure to pass parameters to Access programs
      *
     D*AOFMTS        E DS                  EXTNAME(DSFDY)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Work Variables
     D PMTAG1          S              5A
     D***PMTAG2          S              5A                                                  MD059739
     D PMSGRF          S              8S 0
     D PREF            S             15A
     D PEXIT           S              1A
     D PCANC           S              1A
     D WrkUETR         S             36A
     D WrkF20          S             20A
     D WrkLen          S              3S 0
     D WFound          S              1A
     D WMXRef          S              8S 0
     D WSeqNo          S              4S 0
     D WrkENAM         S            100A
     D ZAPGM           S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
     D S0RRN           S              5S 0
     D LINENO          S              2S 0
     D @RUN            S              1A
      /EJECT

      ** Main Processing
     C                   EXSR      SRINIT

     C     PMSGRF        IFNE      *ZERO
     C                   MOVE      '1'           *INKE

     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'

      ** Initialize and Load subfile if *INKE has been set on
      ** (First time through or change of SETLL fields)

     C   KE              EXSR      SrInsSUBF
     C   KE              EXSR      SrLoadSUBF

      ** Display screen

     C                   EXSR      SrDisplay

      ** Process screen if F3 and F12 not taken

     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'

     C     *IN39         CASEQ     '1'           SrLoadSUBF
     C                   END
     C                   END

     C                   ENDDO
     C                   ELSE
     C                   WRITE     FT020023C2
     C                   EXFMT     FT020023F3
     C                   ENDIF

      ** F3 is pressed

     C                   IF        *INKC = *ON
     C                   EVAL      PEXIT = 'Y'
     C                   ELSEIF    *INKL = *ON
     C                   EVAL      PCANC = 'Y'
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrInsSUBF - Initialize Subfile                                  *
      *                                                                 *
      *******************************************************************

     C     SrInsSUBF     BEGSR
      *
      ** Clear subfile
      *
     C                   MOVEA     '0000'        *IN(30)
     C                   WRITE     FT020023C0
     C                   MOVE      '1'           *IN30
     C                   Z-ADD     *ZERO         WSeqNo

     C                   Z-ADD     0             S0RRN
     C                   Z-ADD     0             X0RRN

     C                   IF        WFound  = 'Y'

      ** Get MX Message Reference

     C*****KMEISOM       CHAIN     MEISOML1                                                 MD059739
     C**********         IF        %FOUND(MEISOML1)                                         MD059739
     C**********         EVAL      WMXRef = OMMSGR                                          MD059739
     C                   Z-ADD     1             WSeqNo
     C     KMEISOD       SETLL     MEISODL1
     C     KMEISOD       READE     MEISODL1                               32
     C                   EVAL      WrkENAM = MEENAM
     C**********         ELSE                                                               MD059739
     C**********         EVAL      WMXRef = *ZERO                                           MD059739
     C**********         EVAL      WFound = 'N'                                             MD059739
     C**********         ENDIF                                                              MD059739

     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrLoadSUBF - Load Subfile                                       *
      *                                                                 *
      *******************************************************************
      *
     C     SrLoadSUBF    BEGSR

     C                   Z-ADD     0             LINENO
     C                   Z-ADD     X0RRN         S0RRN

      ** Load SFL page until SFL page full or end of file

     C     *IN32         DOWEQ     '0'
     C     LINENO        ANDLE     17
     C     WFound        ANDEQ     'Y'

     C                   ADD       1             LINENO

     C     LINENO        IFLE      17

      ** Element Value with more than 60 char

     C                   IF        WrkLen > 60
     C                   EVAL      S0EVAL = %SUBST(MEEVAL:66)
     C                   EVAL      S0ELEM = *BLANKS
     C                   ADD       1             S0RRN                31
     C                   Z-ADD     S0RRN         C0SFRC
     C                   Z-ADD     0             WrkLen
     C                   WRITE     FT020023S0

     C                   ELSE

      ** First 60 char of Element Value

     C                   EVAL      S0EVAL = MEEVAL
     C                   EXSR      SrEName
     C                   ADD       1             S0RRN                31

      ** Write subfile record number

     C                   Z-ADD     S0RRN         C0SFRC
     C                   WRITE     FT020023S0
     C                   ADD       1             WSeqNo

      ** Check the length of Element Value

     C                   EVAL      WrkLen = %LEN(%TRIM(MEEVAL))
     C                   ENDIF

     C                   ENDIF

      ** Read next record

     C     LINENO        IFLE      17
     C     WrkLen        ANDLE     60
     C                   EVAL      WrkENAM = *BLANKS
     C     KMEISOD       READE     MEISODL1                               32
     C                   EVAL      WrkENAM = MEENAM
     C                   ENDIF
     C                   ENDDO

      ** Set Subfile Record Number and Save

     C                   Z-ADD     S0RRN         X0RRN
     C                   EVAL      X0ELEM = DEDESC
     C                   EVAL      X0EVAL = MEEVAL

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrDisplay - Display Subfile                                     *
      *                                                                 *
      *******************************************************************
      *
     C     SrDisplay     BEGSR

      ** If no records displayed, output message

     C     S0RRN         IFEQ      0
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   IF        WFound = 'Y'
     C                   WRITE     FT020023C2
     C                   WRITE     FT020023F2
     C                   EXFMT     FT020023C0
     C                   ELSE
     C                   WRITE     FT020023C2
     C                   EXFMT     FT020023F3
     C                   ENDIF

      ** Clear messages from program message queue

     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR

     C     ZAMSGF        IFEQ      *BLANKS
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   ENDIF

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP

     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SRINIT - Initial Program Subroutine                             *
      *                                                                 *
      *******************************************************************
      *
     C     SRINIT        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMSGRF
     C                   PARM                    PREF
     C                   PARM                    PEXIT
     C                   PARM                    PCANC

      ** Define Key Lists

     C     KMEINDT       KLIST
     C                   KFLD                    PMSGRF
     C                   KFLD                    PMTAG1

     C*****KMEIN35       KLIST                                                              MD059739
     C**********         KFLD                    PMSGRF                                     MD059739
     C**********         KFLD                    PMTAG2                                     MD059739

     C     KMEISOM       KLIST
     C**********         KFLD                    WrkF20                                     MD059739
     C                   KFLD                    WrkUETR

     C     KMEISOD       KLIST
     C                   KFLD                    WMXRef
     C                   KFLD                    WSeqNo

      ** Define all program work fields

     C     *LIKE         DEFINE    S0RRN         X0RRN
     C     *LIKE         DEFINE    S0ELEM        X0ELEM
     C     *LIKE         DEFINE    S0EVAL        X0EVAL
      *
     C                   EVAL      ZAPGM = *BLANKS
     C                   EVAL      ZAPGRL = *BLANKS
     C                   EVAL      ZAMSID = *BLANKS
     C                   EVAL      ZAMSGF = *BLANKS
     C                   EVAL      ZAMSDA = *BLANKS
     C                   EVAL      ZAMSTP = *BLANKS
     C                   EVAL      WrkF20 = *BLANKS
     C                   EVAL      WrkUETR = *BLANKS

     C                   Z-ADD     0             S0RRN
     C                   Z-ADD     0             LINENO
     C                   Z-ADD     0             WrkLen

     C                   EVAL      *IN77 = *OFF

      ** Get Rundate

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA

     C                   MOVEL     PGM           ZAPGM

      ** Set screen constants and output header

     C                   MOVEL     PGM           SPGM
     C                   MOVEL     WSID          SWSID
     C                   MOVEL     USER          SUSER
     C                   MOVEL     AGMRDT        SRUNA
     C                   MOVEL     PREF          SPREF

     C                   EVAL      PMTAG1 = '121:'
     C**********         EVAL      PMTAG2 = ':20:'                                          MD059739

     C     KMEINDT       CHAIN     MEINDTL0
     C                   IF        %FOUND(MEINDTL0)
     C                   EVAL      WrkUETR = DTMFLD
     C                   EVAL      WFound = 'Y'
     C                   EVAL      *IN77 = *ON
     C                   EVAL      SUETR = DTMFLD

     C*****KMEIN35       CHAIN     MEIN35L0                                                 MD059739
     C**********         IF        %FOUND(MEIN35L0)                                         MD059739
     C**********         EVAL      WrkF20 = DSMF35                                          MD059739
     C**********         EVAL      SMSGID = DSMF35                                          MD059739
     C**********         ENDIF                                                              MD059739
     C     KMEISOM       CHAIN     MEISOML2                                                 MD059739
     C                   IF        %FOUND(MEISOML2)                                         MD059739
     C                   EVAL      SMSGID = OMMSID                                          MD059739
     C                   EVAL      WMXRef = OMMSGR                                          MD059739
     C                   ELSE                                                               MD059739
     C                   EVAL      WMXRef = *ZERO                                           MD059739
     C                   EVAL      WFound = 'N'                                             MD059739
     C                   ENDIF                                                              MD059739

     C                   ELSE
     c                   EVAL      WFound = 'N'
     C                   ENDIF

     C                   WRITE     FT020023F1

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrEName - Get the Element Description                           *
      *                                                                 *
      *******************************************************************
      *
     C     SrEName       BEGSR

     C     WrkENAM       CHAIN     MEDESCL1
     C                   IF        %FOUND(MEDESCL1) AND DEDESC <> *BLANKS
     C                   EVAL      S0ELEM = DEDESC
     C                   ELSE
     C                   EVAL      S0ELEM = WrkENAM
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * *PSSR  - Program Exception Error Routine                        *
      *                                                                 *
      *******************************************************************
      *
     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   MOVEL     'FT020023DF'  DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *
      *******************************************************************
