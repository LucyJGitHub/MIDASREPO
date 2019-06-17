     H DEBUG
*****H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2003')                     JMI113
     H COPYRIGHT('(c) Finastra International Limited 2018')                               JMI113
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME GCMS file pre-processing')                    *
      *****************************************************************
      *                                                               *
      *  Midas - ME module                                            *
      *                                                               *
      ***MEJ003*-*GCMS*File*Pre-Processing*****************************                   JMI113
      *  XX113103 - GCMS File Pre-Processing                          *                   JMI113
      *                                                               *
      *  Function:  This program will be called from the GCMS         *
      *             background task to                                *
      *             1) For each member, an index record will be       *
      **************written*to*MGGCMXPD*an*the*message*data*to*********                   JMI113
      **************MGGCMMPD*******************************************                   JMI113
      *             written to XXGCMXPD an the message data to        *                   JMI113
      *             XXGCMMPD                                          *                   JMI113
      *                                                               *
      ***Called*By:*MECJ002*-******************************************                   JMI113
      *  Called By: XXC113102                                         *                   JMI113
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2003*************                   JMI113
      *  (c) Finastra International Limited 2018                      *                   JMI113
      *                                                               *
      *  Last Amend No. JMI113             Date 29May18               *
      *  Prev Amend No. AR913243A          Date 17May12               *
      *                 JMI019             Date 23Feb07               *
      *                 226839             Date 21Apr04               *
      *                 JMI019  *CREATE    Date 23Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1            *
      *  AR913243A - Initialize field WPOINT before opening MGGCMSPD. *
      *              (Child: AR913244)                                *
      *  JMI019 - Upgrade as is except for the following              *
      *           change P@ACCD from 4 to 10                          *
      *           change DBFILE from AOMMODR0 to AOGELRR0             *
      *  226839 - GCMS background job MECJ002 down                    *
      *  JMI019 - Midas GCMS interface                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****50*********EOF*of*MGGCMSPD**********************************                   JMI113
      *****55*********EOF*of*MGGCMSL0**********************************                   JMI113
      *    50         EOF of XXGCMGPD                                 *                   JMI113
      *    55         EOF of XXGCMGL0                                 *                   JMI113
      *    90         General error indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *  SRCONV - Convert ASCII to EBCDIC                             *
      ***SRMDTA*-*Write*header*record*to*MGGCMMPD**********************                   JMI113
      ***SRINDX*-*Write*header*record*to*MGGCMXPD**********************                   JMI113
      *  SRMDTA - Write header record to XXGCMMPD                     *                   JMI113
      *  SRINDX - Write header record to XXGCMXPD                     *                   JMI113
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * GCMS message Interface file
     F**********MGGCMSPD  IF   E             DISK    INFSR(*PSSR)                         JMI113
     FXXGCMGPD  IF   E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     USROPN
      * GCMS message Index
     F**********MGGCMXPD  O    E             DISK    INFSR(*PSSR)                         JMI113
     FXXGCMXPD  O    E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     COMMIT
      * GCMS message Data
     F**********MGGCMMPD  O    E             DISK    INFSR(*PSSR)                         JMI113
     FXXGCMMPD  O    E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     COMMIT
      * GCMS message Logical file
     F**********MGGCMSL0  UF   E             DISK    INFSR(*PSSR)                         JMI113
     F**********                           RENAME(MGGCMSD0:MGGCMSDD)                      JMI113
     FXXGCMGL0  UF   E             DISK    INFSR(*PSSR)                                   JMI113
     F                                     RENAME(XXGCMGD0:XXGCMGDD)                      JMI113
     F                                     PREFIX(D)
     F**********MEJ003AU  O    E             PRINTER                                      JMI113
     FXX113103AUO    E             PRINTER                                                JMI113
      /EJECT
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Account details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
     D**********MEGCMSDA      E DS           256    EXTNAME(MEGCMSDA)                     JMI113
     D XXGCMMDA      E DS           256    EXTNAME(XXGCMMDA)                              JMI113
      *
      ** Data Area giving GCMS Details
      *
      ** Working
     DWMOR             DS
     DJ0MODE
     DJ0MOTM
      *
     DWSZDATA          S              2  0
     DWSZEBC           S              4  0
      ** Used only to define the size of arrays
     DWSDATA           S             40
      ** We use WSEBC to concatenate incoming data after
      ** they have been translated in EBCDIC
     DWSEBC            S           9999
      *
      ** Arrays
     DWDATA            DS
      ** We use the array DATA@ to write records, but also to scan presence
      ** of :tag: of which value are not filled necessary in the same record
      ***in*MGGCMSPD                                                                      JMI113
      ** in XXGCMGPD                                                                      JMI113
     DDATA@                         256    DIM(%SIZE(WSDATA))
      *
      ** Indexes
     DI                S                   LIKE(WSZDATA)
     DWPOS             S                   LIKE(WSZEBC)
      *
      ** Parameters for ZA0140M
     DSSRTN            S              1
     DSSDAYN           S              5  0
     DSSDFMT           S              1
     DSSDATE           S              6  0
     DSSDATA           S              7
     DSSDAT8           S              8  0
     DSSDAT8F          S              8  0
      *
      ** Parameters for AOACCTR0
     DP@RTCD           S              7
     DP@OPTN           S              7
     DP@RETL           S             10
     DP@CNUM           S              6
     DP@CUCD           S              3

     DP@ACCD           S             10                                                       JMI109
     D***P@ACCD*******    S              4                                                    JMI109
     DP@ACSQ           S              2
     DP@BRCA           S              3
      *
      ** Define carriage return/line feed control characters
      *
     D                 DS
     D  W@CR                   1      1    INZ(X'0D')
     D  W@LF                   2      2    INZ(X'25')
     D  W@CRLF                 1      2
      *
     DDLIMTR           DS
      *
      ** To define carriage return delimiters for message scanning
      ** Hex value  '  :'  = CRLF: Start of text/Field Separator
      **             027
      **             D5A
      *
     D  CRLFC                  1      3
     D  BTA                    1      1
     D  BTB                    2      2
     D  CLN                    3      3
      *
      /SPACE 3
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
     C                   MOVEL     *BLANK        DATA@
     C                   Z-ADD     1             WPOS
     C                   Z-ADD     0             WPOINT                                    AR913243A
      *
     C**********         OPEN      MGGCMSPD                                               JMI113
     C                   OPEN      XXGCMGPD                                               JMI113
      *
     C*****1****         SETLL     MGGCMSD0                                               JMI113
     C**********         READ      MGGCMSD0                               50              JMI113
     C     1             SETLL     XXGCMGD0                                               JMI113
     C                   READ      XXGCMGD0                               50              JMI113
     C                   ADD       1             WPOINT           30 0
     C                   Z-ADD     WPOINT        WMARKR           30 0
      *
      ** Obtain Tag 20 Field
      *
     C                   Z-ADD     0             WPOSX             3 0
     C     ':20:'        SCAN      J0DATA        WPOSX
     C                   ADD       4             WPOSX
     C     16            SUBST     J0DATA:WPOSX  WTAG20           16
      *
     C     *IN50         IFEQ      '1'
     C                   EVAL      P#MIR = '*EMPTY'
     C**********         CLOSE     MGGCMSPD                                               JMI113
     C                   CLOSE     XXGCMGPD                                               JMI113
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        WSEBC
      *
     C     *IN50         DOWEQ     '0'
      *
     C     WNMIND        DOWEQ     0
     C     *IN50         ANDEQ     '0'
      *
      ** Append continuation of message
      *
     C     WSEBC         CAT       J0DATA:0      WSEBC
      *
     C**********         READ      MGGCMSD0                               50              JMI113
     C                   READ      XXGCMGD0                               50              JMI113
      *
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             WPOINT
      *
      ** Scan message data to check if it is a  new message
      *
     C                   Z-ADD     0             WNMIND            3 0
     C     ':20:'        SCAN      J0DATA        WNMIND
      *
     C                   ENDDO
      *
     C                   MOVEA     WSEBC         DATA@
      *
      ** Create 'data' record
      *
     C                   EXSR      SRMDTA
      *
      ** Create 'index' record
      *
     C                   EXSR      SRINDX
      *
     C                   MOVE      *BLANKS       WSEBC
     C                   MOVEL     *BLANK        DATA@
     C                   Z-ADD     0             WNMIND
      *
     C                   EXSR      SRREMV
     C                   Z-ADD     WPOINT        WMARKR
      *
     C                   ENDDO
      *
     C**********         CLOSE     MGGCMSPD                                               JMI113
     C                   CLOSE     XXGCMGPD                                               JMI113
      *
     C**********         UNLOCK    MEGCMSDA                                               JMI113
     C                   UNLOCK    XXGCMMDA                                               JMI113
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      **S/R*SRMDTA*Write*header*record*to*MGGCMMPD                    *                   JMI113
      * S/R SRMDTA Write header record to XXGCMMPD                    *                   JMI113
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRMDTA        BEGSR
      *
     C                   Z-ADD     1             I
      *
     C******DTAARA       DEFINE                  MEGCMSDA                                 JMI113
     C******LOCK         IN        MEGCMSDA                                               JMI113
     C     *DTAARA       DEFINE                  XXGCMMDA                                 JMI113
     C     *LOCK         IN        XXGCMMDA                                               JMI113
     C                   MOVEL     J0SEQN        W0SEQN           10
     C                   MOVE      W0SEQN        WSEQN             5 0
     C                   ADD       1             WSEQN
     C                   MOVE      WSEQN         W0SEQN
     C                   MOVEL     W0SEQN        J0SEQN
     C**********         OUT       MEGCMSDA                                               JMI113
     C                   OUT       XXGCMMDA                                               JMI113
      *
     C     DATA@(I)      DOWNE     *BLANK
     C                   MOVEA     DATA@(I)      J0MDTA
     C                   MOVEL     J0SEQN        J0MIR
      *
     C**********         WRITE     MGGCMMD0                             90                JMI113
     C                   WRITE     XXGCMMD0                             90                JMI113
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE
     C**********         MOVEL(P)  'MGGCMMPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  'XXGCMMPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  J0SEQN        DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ADD       1             I
      *
     C     I             IFGT      WSZDATA
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     END_SRMDTA    ENDSR
      *****************************************************************
      **S/R*SRINDX*Write*header*record*to*MGGCMXPD                    *                   JMI113
      * S/R SRINDX Write header record to XXGCMXPD                    *                   JMI113
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRINDX        BEGSR
     C                   MOVEL     '101'         J0MTPY
      *
     C     WBG           IFEQ      0
     C                   MOVEL     BKMABR        J0BRCA
     C                   ENDIF
      *
     C     WBG           IFNE      0
      *
      ** Account line starts with a '/'
      *
     C                   ADD       6             WBG               4 0
      ** If it is a retail number
     C                   IF        (%SUBST(WDATA:WBG+10:2) = *blank)
     C                   EVAL      P@RETL = %SUBST(WDATA:WBG:10)
     C                   MOVEL     *BLANK        P@CNUM
     C                   MOVEL     *BLANK        P@CUCD
     C                   MOVEL     *BLANK        P@ACCD
     C                   MOVEL     *BLANK        P@ACSQ
     C                   MOVEL     *BLANK        P@BRCA
     C                   ELSE
      ** If it is a G/L account number
     C                   MOVEL     *BLANK        P@RETL
     C                   EVAL      P@BRCA = %SUBST(WDATA:WBG:3)
     C                   EVAL      P@CNUM = %SUBST(WDATA:WBG+3:6)
     C                   EVAL      P@CUCD = %SUBST(WDATA:WBG+9:3)
     C                   EVAL      P@ACCD = %SUBST(WDATA:WBG+12:10)                           JMI019
     C                   EVAL      P@ACSQ = %SUBST(WDATA:WBG+22:2)                            JMI019
     C**********         EVAL      P@ACCD = %SUBST(WDATA:WBG+12:4)                            JMI019
     C**********         EVAL      P@ACSQ = %SUBST(WDATA:WBG+16:2)                            JMI019
     C                   ENDIF
     C                   CALLB     'AOACCTR0'                           90
     C                   PARM                    P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@RETL
     C                   PARM                    P@CNUM
     C                   PARM                    P@CUCD
     C                   PARM                    P@ACCD
     C                   PARM                    P@ACSQ
     C                   PARM                    P@BRCA
     C                   PARM                    ACCNT
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     004           DBASE
     C                   MOVEL(P)  'AOACCTR0'    DBFILE
     C                   MOVEL(P)  'CALL'        DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P@RTCD        IFNE      *BLANK
     C                   MOVEL     BKMABR        J0BRCA
     C                   ELSE
     C                   MOVEL     BRCA          J0BRCA
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Convert Midas rundate in CCYYMMDD
      *
     C                   CALLB     'ZA0140M'                            90
     C                   PARM                    SSRTN
     C                   PARM      BJRDNB        SSDAYN
     C                   PARM      AGDFF         SSDFMT
     C                   PARM                    SSDATE
     C                   PARM                    SSDATA
     C                   PARM                    SSDAT8
     C                   PARM                    SSDAT8F
      *
     C     SSRTN         IFNE      '0'
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE
     C                   MOVEL(P)  'ZA0140M'     DBFILE
     C                   MOVEL(P)  BJRDNB        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      SSDAT8        J0MODE
      ** Retrieve time HHMMSS
     C                   TIME                    J0MOTM
      *
     C                   MOVEL     J0SEQN        J0MIRF
     C                   MOVEL     'N'           J0MPRY
     C                   MOVEL     WMOR          J0MOR
     C                   MOVEL     *BLANK        J0IMPF
      *
     C**********         WRITE     MGGCMXD0                             90                JMI113
     C                   WRITE     XXGCMXD0                             90                JMI113
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE
     C**********         MOVEL(P)  'MGGCMXPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  'XXGCMXPD'    DBFILE                                   JMI113
     C                   MOVEL(P)  J0SEQN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     END_SRINDX    ENDSR
      *****************************************************************
      **S/R*SRREMV*Delete*message*from*MGGCMSPD************************                   JMI113
      * S/R SRREMV Delete message from XXGCMGPD                       *                   JMI113
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRREMV        BEGSR
     C*****WMARKR        SETLL     MGGCMSDD                                               JMI113
     C**********         READ      MGGCMSDD                               55              JMI113
     C     WMARKR        SETLL     XXGCMGDD                                               JMI113
     C                   READ      XXGCMGDD                               55              JMI113
      *
      ** Obtain Tag 20 Field of message to be deleted
      *
     C                   Z-ADD     0             WPOSY             3 0
     C     ':20:'        SCAN      DJ0DATA       WPOSY
     C                   ADD       4             WPOSY
     C     16            SUBST     DJ0DATA:WPOSY WTAG20D          16
      *
     C     WTAG20        IFEQ      WTAG20D
     C     *IN55         ANDEQ     '0'
     C**********         DELETE    MGGCMSDD                                               JMI113
     C                   DELETE    XXGCMGDD                                               JMI113

     C                   Z-ADD     0             WENDIN            3 0
     C     WENDIN        DOWEQ     0
     C     *IN55         ANDEQ     '0'
     C**********         READ      MGGCMSDD                               55              JMI113
     C                   READ      XXGCMGDD                               55              JMI113
      *
      ** Scan message data to check if it is end of message
      *
     C                   Z-ADD     0             WENDIN
     C     CRLFC         CAT       '}':0         WDLIM             4
     C     WDLIM         SCAN      DJ0DATA       WENDIN
     C                   IF        *IN55 = '0'                                                226839
     C**********         DELETE    MGGCMSDD                                               JMI113
     C                   DELETE    XXGCMGDD                                               JMI113
     C                   ENDIF                                                                226839
     C                   ENDDO
      *
     C                   Z-ADD     1             WPOINT
      *
      ** Obtain Tag 20 field of Message
      *
     C                   Z-ADD     0             WTAGIN
     C     ':20:'        SCAN      J0DATA        WTAGIN
     C                   ADD       4             WTAGIN            3 0
     C     16            SUBST     J0DATA:WTAGIN WTAG20
      *
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ROLBK
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM *******************************************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MIR            10
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBASE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVEL     'MEJ003M'     DBPGM
     C                   OUT       LDA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Retrieve Bank Details
      *
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     007           DBASE
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve General Ledger details to get main branch
      *
     C                   CALLB     'AOGELRR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDGELR        PARM      SDGELR        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     008           DBASE
     C                   MOVEL(P)  'AOGELRR0'    DBFILE                                       JMI019
     C***********        MOVEL(P)  'AOMMODR0'    DBFILE                                       JMI019
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WSZDATA = %SIZE(WSDATA)
     C                   EVAL      WSZEBC = %SIZE(WSEBC)
      *
      ** Setup field for 'CRLF', used in SCAN checking to determine
      ** delimiters for Block data strings
      *
     C                   BITOFF    '01236'       BTA
     C                   BITON     '457'         BTA
     C                   BITOFF    '01346'       BTB
     C                   BITON     '257'         BTB
     C                   MOVE      '-'           CLN
      *
     C                   ENDSR
      *****************************************************************
      * SAMPLE ERROR                                                  *
      * Its a sample to show how handle errors. Don't call it         *
      *****************************************************************
     C     SPLERR        BEGSR
      *
      ***************** FOR EACH DATABASE ERROR *************************
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     000           DBASE
     C                   MOVEL(P)  '(file)'      DBFILE
     C                   MOVEL(P)  '(key)'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSR
      *
      ********************************************************************
