     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Associated groups list and path update')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG1070 - Get Associated Groups and Update Path List          *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192258             Date 20Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 089189             Date 16Jun95               *
     F*                 083679             DATE 15MAR95               *
     F*                 084084             DATE 29FEB95               *
     F*                 083679             DATE 22FEB95               *
     F*                 S01522             DATE 15MAR95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
     F*  192258 - Array index error in CG1070. Double the size of     *
     F*           the array so that d11IRS can have more Groups Sets  *
     F*           under it.                                           *
     F*  089189 - Miscellaneous changes.                              *
     F*  083679 - Add absolute sequence to CGWPRDE2                   *
     F*  084084 - Allow for redirection in repeaters                  *
     F*  083679 - SRRDE2 files accesses out of date cf. CGWPRDE2      *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG1000DFPG
     F*CGGSASL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RSQ : Group Set Association     From/Seq/To Group Set
      *
     F*CGRASCL1IF**E           K        DISK                              083679
     F*CGRASCL2* IF   E           K DISK                                         083679     MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGGSASL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGPDECL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGPATHL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RSQ : Path                      By Group sets
      *
     F*CGPATHL0* IF A E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * UPD : Path                      Update Index
      *
     F*CGGSETL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RTV : Group Set Definition      Retrieval index
      *
     F*CGRDTAL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
     F*CGWPRDE1* IF A E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
     F*CGWPRDE2* IF A E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
     F*CGW1LAYO* IF A E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *                                                                   084084
     F*CGWPLAYO* IF   E           K DISK    USROPN                               084084     MD054955
     F**********                           INFSR(SRFILE)                        084084      MD054955
      *
      * QTEMP files
      *
     F*CGPASCPD* O    E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F**********                           COMMIT                                           MD054955
      *
     F*CGPDECPD* O    E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F**********                           COMMIT                                           MD054955
      *
      * Layout data files (TOOL member used)
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D/COPY WNCPYSRC,CG1070E003
     D**********          AG         20  6                                192258
     D AG              S              6    DIM(40)                                               192
     D/COPY WNCPYSRC,CG1070E004
      *
      * Array of Associated Groups
      *
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG1000DEPG
      /EJECT
     D CGGSAS        E DS                  EXTNAME(CGGSAJW0)                                MD054955
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG1000DIPG
      /EJECT
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D CGDTA         E DS                  EXTNAME(CGDTA)
     D CGLDA         E DS                  EXTNAME(CGLDA)                       S01194
      *
      *  User Defined Correspondence Data Area
      *
      /EJECT
      * Parameter declarations
     D O#TGDS          DS
      * O : To Groups
     D/COPY WNCPYSRC,CG1070I003
     D  O#TGRP                 1    120
     D/COPY WNCPYSRC,CG1070I004
     D I#PTDS          DS
      * I : Current Path
     D  I#PATH                 1    240
      *
     D PATHDS          DS
     D  I#P1                   1    256
     D  I#P2                 257    376
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D                 DS
     D  L@SEQA                 1      3
     D  #SEQAN                 1      3  0
      *                                                                   084084
     D REDIDS          DS                                                       084084
     D  @REDIR                 1      3                                         084084
     D  #REDIR                 1      3  0 INZ(1)                               084084
      *
     D***********   'DATA'                C         LDATA                 084084
     D LDATA           C                   CONST('D')                           084084
     D LREPE           C                   CONST('R')                           084084
      *
      /EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    W0ACT             8            Action Code
     C                   PARM                    I#FGRP            6
     C                   PARM                    O#ENTY            5 0
     C                   PARM                    O#TGDS
     C                   PARM                    I#PTDS
      *
      *  Set up primary reference
      *
     C                   MOVEL     I#FGRP        W0PREF
      *
     C*****PL8020        PLIST                                                              MD054955
     C**********         PARM      *BLANKS       P@RTCD            7                        MD054955
     C**********         PARM      '*LAYDATA'    P@ACTN            8                        MD054955
     C**********         PARM      LPPLAN        #PPLAN                                     MD054955
     C**********         PARM      *BLANKS       PATHDS                                     MD054955
      **********                                                                            MD054955
     C******LIKE         DEFINE    LPPLAN        #PPLAN                                     MD054955
      *
     C     *DTAARA       DEFINE    *LDA          CGLDA
     C                   IN        CGLDA
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Reset return code
      *
     C                   MOVEL     *BLANKS       P0RTN
      *
      *  Open files in QTEMP
      *
     C*****W0ACT         CASEQ     '*RDEDATA'    SROPE1                                     MD054955
     C*****W0ACT         CASEQ     '*DISPLAY'    SROPE2                                     MD054955
     C**********         END                                                                MD054955
      *
      *  Validate depending on action code
      *
     C     W0ACT         CASEQ     '*LIST   '    SRLIST
     C*****W0ACT         CASEQ     '*PATH   '    SRPATH                                     MD054955
     C*****W0ACT         CASEQ     '*RDEDATA'    SRPATH                                     MD054955
     C*****W0ACT         CASEQ     '*DISPLAY'    SRPATH                                     MD054955
     C**********         CAS                     SRACT                                      MD054955
     C                   END
      *
     C***********          EXSR SRCLOS                              089189089189
     C**********         EXSR      SRCLOS                                                   MD054955
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
     CSR   *INZSR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     '*INZSR'      @STK(Q)
      *  Set plane defaults
     C**********         Z-ADD     1             LPSROW                                     MD054955
     C**********         Z-ADD     1             LPSCOL                                     MD054955
     C**********         Z-ADD     66            LPEROW                                     MD054955
     C**********         Z-ADD     132           LPECOL                                     MD054955
     C**********         Z-ADD     LPSROW        LPFROW                                     MD054955
     C**********         Z-ADD     LPSCOL        LPFCOL                                     MD054955
     C**********         Z-ADD     LPEROW        LPOROW                                     MD054955
     C**********         Z-ADD     LPECOL        LPOCOL                                     MD054955
      **********                                                                            MD054955
     C**********         Z-ADD     LPSROW        #PSROW                                     MD054955
     C**********         Z-ADD     LPSCOL        #PSCOL                                     MD054955
     C**********         Z-ADD     LPEROW        #PEROW                                     MD054955
     C**********         Z-ADD     LPECOL        #PECOL                                     MD054955
     C**********         Z-ADD     LPFROW        #PFROW                                     MD054955
     C**********         Z-ADD     LPFCOL        #PFCOL                                     MD054955
     C**********         Z-ADD     LPOROW        #POROW                                     MD054955
     C**********         Z-ADD     LPOCOL        #POCOL                                     MD054955
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLIST   : Get List of Associated Groups                     *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRLIST        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRLIST'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG1070LIST
      *
      *  Set number of entries to zero amd initialise array
      *
     C                   Z-ADD     0             O#ENTY
     C     *LIKE         DEFINE    O#ENTY        X
     C                   Z-ADD     0             X
     C                   MOVEL     *BLANKS       AG
      *
      *  Set pointer to from group
      *
     C     KPOS          KLIST
     C                   KFLD                    GAFGST                         From Linked Gro
      * Setup key
     C                   MOVEL     I#FGRP        GAFGST                         From Linked Gro
      *
     C*****KPOS*         SETLL     @GSASL2                                                  MD054955
     C*****KPOS*         READE     @GSASL2                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGGSAJW0                                                              MD054955
     C+ where GAFGST = :GAFGST and GARECI = 'D'                                             MD054955
     C+ order by GAFGST, GASEQA, GALGST                                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
      *  Set up list of groups
      *
     C******IN90         DOWEQ     '0'                                                      MD054955
     C*****X****         ANDLE     40                                                 19225 MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and X <= 40                                              MD054955
      *
      *  Add 1 to group and place in array
      *
     C                   ADD       1             O#ENTY
     C                   ADD       1             X
     C                   MOVEL     GALGST        AG(X)
      *
     C*****KPOS*         READE     @GSASL2                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDDO
      *
      *  If number of entries is zero set return code to show this
      *
     C     O#ENTY        IFEQ      0
     C                   MOVEL     'CGD1085'     P0RTN
     C                   ENDIF
      *
      *  Set To Groups to those found
      *
     C                   MOVEA     AG            O#TGRP
      *
      *  Unwind subroutine stack name
      *
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXLIST        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPATH   : Look for Path and if not found create             *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     C**********H        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRPATH'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070PATH                                                             MD054955
      **********                                                                            MD054955
      **********key list for path                                                           MD054955
      **********                                                                            MD054955
     C**********S        KLIST                                                              MD054955
     C**********         KFLD                    EPLEV1                                     MD054955
     C**********         KFLD                    EPLEV2                                     MD054955
     C**********         KFLD                    EPLEV3                                     MD054955
     C**********         KFLD                    EPLEV4                                     MD054955
     C**********         KFLD                    EPLEV5                                     MD054955
     C**********         KFLD                    EPLEV6                                     MD054955
     C**********         KFLD                    EPLEV7                                     MD054955
     C**********         KFLD                    EPLEV8                                     MD054955
     C**********         KFLD                    EPLEV9                                     MD054955
     C**********         KFLD                    EPLEV0                                     MD054955
      **********                                                                            MD054955
      **********ath group set fields                                                        MD054955
      **********                                                                            MD054955
     C**********         MOVEL     *BLANKS       EPLEV1                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV2                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV3                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV4                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV5                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV6                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV7                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV8                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV9                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV0                                     MD054955
      **********                                                                            MD054955
      **********peating Path/Top Group Set                                                  MD054955
      **********                                                                            MD054955
     C**********         Z-ADD     2             Y#                7 0                      MD054955
     C**********         Z-ADD     0             X#                7 0                      MD054955
     C**********         Z-ADD     0             C#                5 0                      MD054955
     C**********         MOVEL     'N'           ##NONR            1                        MD054955
      **********                                                                            MD054955
     C**********         DOUEQ     'CGD1087'                                                MD054955
     C**********         EXSR      SRNGRP                                                   MD054955
      **********                                                                            MD054955
      **********f group set is top or repeating                                             MD054955
      **********                                                                            MD054955
     C**********T        CHAIN     @GSETL1                            90                    MD054955
      **********                                                                            MD054955
      **********found error                                                                 MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGGSETL1'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     1             W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********is a repeating group                                                        MD054955
      **********                                                                            MD054955
     C**********C        IFNE      'N'                                                      MD054955
     C**********R        ANDEQ     'Y'                                                      MD054955
     C**********         MOVEL     'CGGSETL1'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     2             W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'CGD1088'     W0MSGD                         ************MD054955
     C**********         MOVEL     'CGUSRMSG'    W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********C        IFEQ      'N'                                                      MD054955
     C**********T        ANDNE     'T'                                                      MD054955
     C**********R        ANDNE     'Y'                                                      MD054955
      **********                                                                            MD054955
      **********th                                                                          MD054955
      **********                                                                            MD054955
     C**********S        CHAIN     @PATHL2                            90                    MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    '*PATH   '                                               MD054955
      **********                                                                            MD054955
      ********** not found add to database                                                  MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         EXSR      SRADDP                                                   MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         WHENEQ    '*RDEDATA'                                               MD054955
      **********                                                                            MD054955
      ********** to locate path here is terminal error                                      MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL2'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     10            W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         MOVE      EPPATH        #RRPTH                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    1                                                        MD054955
     C**********         MOVEL     EPLEV1        #RGRPS                                     MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     EPLEV2        #RGRPS                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     EPLEV3        #RGRPS                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     EPLEV4        #RGRPS                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     EPLEV5        #RGRPS                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     EPLEV6        #RGRPS                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     EPLEV7        #RGRPS                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     EPLEV8        #RGRPS                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     EPLEV9        #RGRPS                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     EPLEV0        #RGRPS                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********         EXSR      SRRDE1                                                   MD054955
      **********                                                                            MD054955
     C**********         WHENEQ    '*DISPLAY'                                               MD054955
      **********                                                                            MD054955
      ********** to locate path here is terminal error                                      MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL2'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     20            W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         MOVE      EPPATH        L#RPTH                                     MD054955
      **********                                                                            MD054955
     C**********         EXSR      SRDISP                                                   MD054955
      **********                                                                            MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
      **********ath group set fields                                                        MD054955
      **********                                                                            MD054955
     C**********         MOVEL     *BLANKS       EPLEV1                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV2                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV3                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV4                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV5                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV6                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV7                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV8                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV9                                     MD054955
     C**********         MOVEL     *BLANKS       EPLEV0                                     MD054955
      **********                                                                            MD054955
      **********d non-repeating path                                                        MD054955
      **********                                                                            MD054955
     C**********         Z-ADD     0             C#                                         MD054955
     C**********         MOVEL     'Y'           ##NONR            1                        MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      ********** level                                                                      MD054955
      **********                                                                            MD054955
     C**********         ADD       1             C#                                         MD054955
      **********                                                                            MD054955
      **********ey to path file by group set                                                MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    1                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV1                                     MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV2                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV3                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV4                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV5                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV6                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV7                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV8                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     ##GSET        EPLEV9                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     ##GSET        EPLEV0                                     MD054955
     C**********         ENDSL                                                              MD054955
     C**********         ENDDO                                                              MD054955
      **********                                                                            MD054955
      **********th for Non-Repeating Group                                                  MD054955
      **********                                                                            MD054955
     C**********S        CHAIN     @PATHL2                            90                    MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    '*PATH   '                                               MD054955
      **********                                                                            MD054955
      ********** not found add to database                                                  MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         EXSR      SRADDP                                                   MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         WHENEQ    '*RDEDATA'                                               MD054955
      **********                                                                            MD054955
      ********** to locate path here is terminal error                                      MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL2'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     11            W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         DEFINE    EPPATH        @RNPTH                                     MD054955
     C**********         MOVE      EPPATH        @RNPTH                                     MD054955
      **********                                                                            MD054955
     C**********         EXSR      SRRDE2                                                   MD054955
      **********                                                                            MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********H        TAG                                                                MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRRDE1   : Write to CGRDE1WP                                 *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********1        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRRDE1'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070RDE1                                                             MD054955
      **********                                                                            MD054955
      **********key list for QTEMP files                                                    MD054955
      **********                                                                            MD054955
     C**********1        KLIST                                                              MD054955
     C**********         KFLD                    #LPATH                                     MD054955
      **********                                                                            MD054955
     C**********0        KLIST                                                              MD054955
     C**********         KFLD                    #AFGST                                     MD054955
     C**********         KFLD                    #ALGST                                     MD054955
      **********                                                                            MD054955
     C**********         DEFINE    C#            C@                                         MD054955
     C**********         Z-ADD     C#            C@                                         MD054955
      **********                                                                            MD054955
     C**********         DOWGT     1                                                        MD054955
      **********                                                                            MD054955
     C**********         CLEAR                   @RD1FMT                                    MD054955
      **********                                                                            MD054955
     C**********S        CHAIN     @PATHL2                            90                    MD054955
      **********                                                                            MD054955
      ********** to locate path here is terminal error                                      MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL2'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     12            W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         MOVE      EPPATH        #LPATH                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    1                                                        MD054955
     C**********         MOVEL     EPLEV1        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV1                                     MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     EPLEV2        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV2                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     EPLEV3        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV3                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     EPLEV4        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV4                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     EPLEV5        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV5                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     EPLEV6        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV6                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     EPLEV7        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV7                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     EPLEV8        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV8                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     EPLEV9        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV9                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     EPLEV0        #ALGST                                     MD054955
     C**********         CLEAR                   EPLEV0                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********1        SETLL     @RD1FMT                                91                MD054955
     C**********         SUB       1             C@                                         MD054955
      **********                                                                            MD054955
     C**********S        CHAIN     @PATHL2                            90                    MD054955
      **********                                                                            MD054955
      ********** to locate path here is terminal error                                      MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL2'    W0FILE                                     MD054955
     C**********         MOVEL     ##GSET        W0KEY                          ************MD054955
     C**********         Z-ADD     13            W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5004'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         MOVE      EPPATH        #FPATH                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    1                                                        MD054955
     C**********         MOVEL     EPLEV1        #AFGST                                     MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     EPLEV2        #AFGST                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     EPLEV3        #AFGST                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     EPLEV4        #AFGST                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     EPLEV5        #AFGST                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     EPLEV6        #AFGST                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     EPLEV7        #AFGST                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     EPLEV8        #AFGST                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     EPLEV9        #AFGST                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     EPLEV0        #AFGST                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********         IFEQ      *OFF                                                     MD054955
     C**********T        CHAIN     @GSETL1                            90                    MD054955
     C**********         MOVEL     GSDESC        #GSDES                                     MD054955
     C**********0        CHAIN     @GSASL1                            90                    MD054955
     C**********         MOVEL     GADESC        #GADES                                     MD054955
     C**********         WRITE     @RD1FMT                                                  MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRRDE2   : Write to CGRDE2WP                                 *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********2        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRRDE2'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070RDE2                                                             MD054955
      **********                                                                            MD054955
      **********key list for QTEMP files                                                    MD054955
      **********                                                                            MD054955
     C**********2        KLIST                                                              MD054955
     C**********         KFLD                    #RRPTH                                     MD054955
     C**********         KFLD                    @RNPTH                                     MD054955
     C***********          KFLD           #RGRPS                          083679            MD054955
     C***********          KFLD           #AGRPS                          083679            MD054955
      **********                                                                            MD054955
     C**********3        KLIST                                                              MD054955
     C***********          KFLD           #RGRPS                          083679            MD054955
     C**********         KFLD                    #FGRPS                                     MD054955
     C**********         KFLD                    #TGRPS                                     MD054955
      **********                                                                            MD054955
     C**********         DEFINE    #RGRPS        #FGRPS                                     MD054955
     C**********         DEFINE    #AGRPS        #TGRPS                                     MD054955
      **********                                                                            MD054955
     C**********4        KLIST                                                              MD054955
     C**********         KFLD                    #TGRPS                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    1                                                        MD054955
     C**********         MOVEL     #RGRPS        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV1        #TGRPS                                     MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     EPLEV1        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV2        #TGRPS                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     EPLEV2        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV3        #TGRPS                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     EPLEV3        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV4        #TGRPS                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     EPLEV4        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV5        #TGRPS                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     EPLEV5        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV6        #TGRPS                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     EPLEV6        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV7        #TGRPS                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     EPLEV7        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV8        #TGRPS                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     EPLEV8        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV9        #TGRPS                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     EPLEV9        #FGRPS                                     MD054955
     C**********         MOVEL     EPLEV0        #TGRPS                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********2        CHAIN     @RD2FMT                            90                    MD054955
      **********                                                                            MD054955
     C**********         IFEQ      *ON                                                      MD054955
      **********                                                                            MD054955
     C**********3        CHAIN     @GSASL1                            91                    MD054955
     C**********4        CHAIN     @GSETL1                            92                    MD054955
      **********                                                                            MD054955
     C***********#TGRPS    CHAIN@RASCL1              90                   083679            MD054955
     C**********S        CHAIN     @RASCL2                            90              08367 MD054955
     C**********         DOWEQ     *OFF                                                     MD054955
      **********                                                                            MD054955
     C**********Y        CLEAR                   @RD2FMT                                    MD054955
      **********                                                                            MD054955
     C**********         MOVE      GADESC        ##ADES                                     MD054955
     C**********         MOVE      GASEQA        ##SEQA                                     MD054955
     C**********         MOVE      GSDESC        ##SDES                                     MD054955
      **********                                                                            MD054955
     C**********         MOVE      @RNPTH        #RNPTH                                     MD054955
     C**********         MOVEL     RADESC        #RADES                                     MD054955
     C**********         MOVE      RASEQA        #ASEQA                                     MD054955
     C**********         MOVE      #TGRPS        #AGRPS                                     MD054955
     C**********         MOVE      RARDE         #ARDE                                      MD054955
     C**********         DEFINE    #DOSEQ        W#OSEQ                                     MD054955
     C**********Q        ADD       1             W#OSEQ                                     MD054955
     C**********         Z-ADD     W#OSEQ        #DOSEQ                                     MD054955
      **********                                                                            MD054955
     C**********         CHAIN     @RDTAL1                            90                    MD054955
     C**********         IFEQ      *OFF                                                     MD054955
     C**********         MOVEL     RDDESC        #RDDES                                     MD054955
     C**********         MOVEL     RDFOPT        #RFOPT                                     MD054955
     C**********         MOVE      RDELYP        #DELYP                                     MD054955
     C**********         MOVE      RDETXT        #DETXT                                     MD054955
     C**********         Z-ADD     RDMAXL        #DMAXL                                     MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         WRITE     @RD2FMT                                                  MD054955
      **********                                                                            MD054955
     C***********#TGRPS    READE@RASCL1                  90               083679            MD054955
     C**********S        READE     @RASCL2                                90          08367 MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRDISP   : Generate Display Data                             *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********P        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRDISP'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070DISP                                                             MD054955
      **********                                                                            MD054955
     C**********2        KLIST                                                              MD054955
     C**********         KFLD                    #@LAYO                                     MD054955
     C**********         KFLD                    L#RPTH                                     MD054955
      **********                                                                            MD054955
     C**********1        KLIST                                                              MD054955
     C**********         KFLD                    L#RPTH                                     MD054955
      **********                                                                            MD054955
     C**********Y        RESET                   @LAYFW1                                    MD054955
      **********                                                                            MD054955
     C**********2        CHAIN     @PDECL2                            90                    MD054955
      **********                                                                            MD054955
      **********f existing or new layout                                                    MD054955
      **********                                                                            MD054955
     C**********         IFEQ      1                                                        MD054955
     C**********Y        ANDEQ     *BLANKS                                                  MD054955
      **********                                                                            MD054955
     C**********         MOVE      'N'           OLDLAY                                     MD054955
     C**********         MOVE      'Y'           OLDLAY                                     MD054955
     C**********         OUT       CGLDA                                                    MD054955
      **********                                                          084084            MD054955
      **********ise redirection index                                     084084            MD054955
      **********                                                          084084            MD054955
     C**********         RESET                   REDIDS                                     MD054955
      **********                                                                            MD054955
      ********** traverse layout structure to initialise with layout                        MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********Y        WHENEQ    'Y'                                                      MD054955
     C***********          EXSR SRCLOS                              089189089189            MD054955
     C**********         EXSR      SRCLOS                                                   MD054955
     C**********         CALL      'CGC8020'     PL8020                 9090                MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********D        OREQ      '*ERROR*'                                                MD054955
     C**********         MOVEL     'CGC8020'     W0FILE                                     MD054955
     C**********         MOVEL     '*CALL'       W0KEY                          ************MD054955
     C**********         Z-ADD     5             W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5003'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C***********          EXSR SROPE2                              089189089189            MD054955
     C**********         EXSR      SROPE2                                                   MD054955
      **********                                                                            MD054955
     C**********Y        WHENEQ    'N'                                                      MD054955
     C**********         Z-ADD     C#            L#DCOL                                     MD054955
     C**********         Z-ADD     0             #SEQAN                                     MD054955
     C**********         MOVE      L@SEQA        L#SEQA                                     MD054955
      **********                                                          084084            MD054955
     C**********         MOVEL     EPLEV1        ##PLAN                                     MD054955
     C**********         MOVE      'R'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
      **********                                                          084084            MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
     C**********         EXSR      SR@LAY                                                   MD054955
      **********ociated plane                                                               MD054955
     C**********         ADD       1             #SEQAN                                     MD054955
     C**********         MOVE      L@SEQA        L#SEQA                                     MD054955
     C**********         MOVEL     L#PLAN        L#PPLA                                     MD054955
      **********                                                          084084            MD054955
     C**********         MOVEL     L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      'D'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
      **********                                                          084084            MD054955
     C**********         ADD       1             L#DCOL                                     MD054955
     C**********         MOVE      L#RPTH        L#LRPT                                     MD054955
     C**********         CLEAR                   L#RPTH                                     MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
      **********                                                                            MD054955
     C**********         EXSR      SR@LAY                                                   MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         IFGT      1                                                        MD054955
      **********ne plane names                                                              MD054955
     C**********         SELECT                                                             MD054955
     C**********         WHENEQ    2                                                        MD054955
     C**********         MOVEL     EPLEV1        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV2        L#PLAN                                     MD054955
     C**********         WHENEQ    3                                                        MD054955
     C**********         MOVEL     EPLEV2        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV3        L#PLAN                                     MD054955
     C**********         WHENEQ    4                                                        MD054955
     C**********         MOVEL     EPLEV3        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV4        L#PLAN                                     MD054955
     C**********         WHENEQ    5                                                        MD054955
     C**********         MOVEL     EPLEV4        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV5        L#PLAN                                     MD054955
     C**********         WHENEQ    6                                                        MD054955
     C**********         MOVEL     EPLEV5        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV6        L#PLAN                                     MD054955
     C**********         WHENEQ    7                                                        MD054955
     C**********         MOVEL     EPLEV6        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV7        L#PLAN                                     MD054955
     C**********         WHENEQ    8                                                        MD054955
     C**********         MOVEL     EPLEV7        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV8        L#PLAN                                     MD054955
     C**********         WHENEQ    9                                                        MD054955
     C**********         MOVEL     EPLEV8        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV9        L#PLAN                                     MD054955
     C**********         WHENEQ    10                                                       MD054955
     C**********         MOVEL     EPLEV9        L#PPLA                                     MD054955
     C**********         MOVEL     EPLEV0        L#PLAN                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                          084084            MD054955
     C**********         MOVEL     L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      'R'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
      **********                                                          084084            MD054955
     C**********         MOVEL     L#PPLA        ##PLAN                                     MD054955
     C**********         MOVE      'R'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PPLA                                     MD054955
      **********                                                          084084            MD054955
      **********s must connect                                            084084            MD054955
      **********                                                          084084            MD054955
     C**********         DEFINE    #REDIR        @@EDIR                                     MD054955
     C**********         Z-ADD     #REDIR        @@EDIR                                     MD054955
      **********                                                          084084            MD054955
     C**********         DO        @@EDIR                                                   MD054955
      **********                                                          084084            MD054955
     C**********         MOVEL     L#PPLA        ##PLAN                                     MD054955
     C**********         MOVE      'R'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L@PPLA                                     MD054955
     C**********         DEFINE    L#PLAN        L@PPLA                                     MD054955
      **********                                                          084084            MD054955
     C**********A        SETLL     @LAYFMT                                30                MD054955
      **********                                                          084084            MD054955
     C**********         IFEQ      *ON                                                      MD054955
     C**********         MOVE      L@PPLA        L#PPLA                                     MD054955
     C**********         LEAVE                                                              MD054955
     C**********         END                                                                MD054955
      **********                                                          084084            MD054955
     C**********         SUB       1             #REDIR                                     MD054955
      **********                                                          084084            MD054955
     C**********         END                                                                MD054955
      **********                                                          084084            MD054955
     C**********         Z-ADD     @@EDIR        #REDIR                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********Y        WHENEQ    'Y'                                                      MD054955
      **********                                                                            MD054955
      **********list: add to unconnected list                                               MD054955
      **********                                                                            MD054955
     C**********         IFEQ      *ON                                                      MD054955
      **********                                                                            MD054955
     C**********         Z-ADD     C#            L#DCOL                                     MD054955
     C**********         MOVEL     '*LOOSE'      L#LRPT                                     MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
      **********ociated plane                                                               MD054955
     C**********         MOVEL     L#PLAN        L#PPLA                                     MD054955
     C**********         MOVE      'NEW'         L#SEQA                                     MD054955
      **********                                                                            MD054955
     C**********         MOVEL     L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      'D'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
      **********                                                                            MD054955
     C**********         ADD       1             L#DCOL                                     MD054955
     C**********         MOVE      L#RPTH        L#LRPT                                     MD054955
     C**********         CLEAR                   L#RPTH                                     MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
      **********                                                                            MD054955
      **********se traverse layout from this point                                          MD054955
      **********                                                                            MD054955
     C**********         ELSE                                                               MD054955
      **********                                                                            MD054955
     C**********N        SETLL     @LAYFMT                                30    089189   084MD054955
     C***********          EXSR SRCLOS                              089189089189            MD054955
     C**********         EXSR      SRCLOS                                                   MD054955
      **********                                                                            MD054955
     C**********         IFEQ      *OFF                                         089189      MD054955
      **********                                                                            MD054955
     C**********         CALL      'CGC8020'     PL8020                 9090                MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********D        OREQ      '*ERROR*'                                                MD054955
     C**********         MOVEL     'CGC8020'     W0FILE                                     MD054955
     C**********         MOVEL     '*CALL'       W0KEY                          ************MD054955
     C**********         Z-ADD     6             W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'MEM5003'     W0MSGD                         ************MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         END                                                    089189      MD054955
      **********                                                                            MD054955
     C***********          EXSR SROPE2                              089189089189            MD054955
     C**********         EXSR      SROPE2                                                   MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********Y        WHENEQ    'N'                                                      MD054955
      **********                                                                            MD054955
      **********f repeater in list first                                                    MD054955
      **********                                                                            MD054955
     C**********1        CHAIN     @LAYFW1                            90                    MD054955
      **********                                                                            MD054955
     C**********         IFEQ      *ON                                                      MD054955
      **********add plane                                                                   MD054955
     C**********         Z-ADD     C#            L#DCOL                                     MD054955
     C**********         ADD       1             #SEQAN                                     MD054955
     C**********         MOVE      L@SEQA        L#SEQA                                     MD054955
      **********                                                          084084            MD054955
     C**********N        SETLL     @LAYFMT                                30                MD054955
      **********icate increment redirection count                         084084            MD054955
     C**********         IFEQ      *ON                                                      MD054955
      **********                                                                            MD054955
     C**********         ADD       1             #REDIR                                     MD054955
      **********                                                                            MD054955
     C**********         MOVEL     L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      'R'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
     C**********         END                                                                MD054955
      **********                                                          084084            MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
      **********                                                                            MD054955
     C**********         EXSR      SR@LAY                                                   MD054955
      **********ociated plane                                                               MD054955
     C**********         ADD       1             #SEQAN                                     MD054955
     C**********         MOVE      L@SEQA        L#SEQA                                     MD054955
     C**********         MOVEL     L#PLAN        L#PPLA                                     MD054955
      **********                                                                            MD054955
     C**********         MOVEL     L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      'D'           #NAMEI                                     MD054955
     C**********         EXSR      SRNRED                                                   MD054955
     C**********         MOVE      ##PLAN        L#PLAN                                     MD054955
      **********                                                                            MD054955
     C**********         ADD       1             L#DCOL                                     MD054955
     C**********         MOVE      L#RPTH        L#LRPT                                     MD054955
     C**********         CLEAR                   L#RPTH                                     MD054955
     C**********         WRITE     @LAYFW1                                                  MD054955
      **********                                                                            MD054955
     C**********         EXSR      SR@LAY                                                   MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRNRED   : Add re-direction index to name                    *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********D        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRNRED'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070NRED                                                             MD054955
      **********                                                                            MD054955
     C**********         SUBST(P)  ##PLAN        ##PLAN                                     MD054955
      **********                                                                            MD054955
     C**********         SELECT                                                             MD054955
     C**********I        WHENEQ    'D'                                                      MD054955
     C**********N        CAT(P)    LDATA:0       ##PLAN                                     MD054955
     C**********I        WHENEQ    'R'                                                      MD054955
     C**********N        CAT(P)    LREPE:0       ##PLAN                                     MD054955
     C**********         ENDSL                                                              MD054955
      **********                                                                            MD054955
     C**********N        CAT(P)    @REDIR:0      ##PLAN                                     MD054955
      **********                                                                            MD054955
     C**********         DEFINE    L#PLAN        ##PLAN                                     MD054955
     C**********         MOVE      *BLANKS       #NAMEI            1                        MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SR@LAY   : Add QTEMP record & add to layout data             *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********Y        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SR@LAY'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070@LAY                                                             MD054955
      **********                                                                            MD054955
     C**********         RESET                   @PDECPD                                    MD054955
     C**********         CLEAR                   @PASCPD                                    MD054955
      **********                                                                            MD054955
     C**********L        IFNE      1                                                        MD054955
     C**********         MOVE      #@LAYO        BALAYO                                     MD054955
     C**********         MOVE      L#PPLA        BAPLAN                                     MD054955
     C**********         MOVE      L#PLAN        BATPLN                                     MD054955
     C**********         MOVE      L@SEQA        BASEQA                                     MD054955
     C**********         MOVE      'D'           BARECI                                     MD054955
     C**********         WRITE     @PASCPD                                                  MD054955
     C**********         ELSE                                                               MD054955
     C**********         MOVE      'Y'           LPTOPP                                     MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
     C**********         MOVE      #@LAYO        LPLAYO                                     MD054955
     C**********         MOVE      L#PLAN        LPPLAN                                     MD054955
     C**********         MOVE      L#RPTH        LPRPTH                                     MD054955
     C**********         MOVE      'D'           LPRECI                                     MD054955
     C**********         WRITE     @PDECPD                                                  MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SROPE1   : Open files in QTEMP                               *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********1        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SROPE1'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070OPE1                                                             MD054955
      **********                                                                            MD054955
      **********les in this mode only                                                       MD054955
      **********                                                                            MD054955
     C***********#OPEN1    IFEQ *BLANKS                                   089189            MD054955
     C**********         OPEN      CGWPRDE1                                                 MD054955
     C**********         OPEN      CGWPRDE2                                                 MD054955
     C**********           MOVE 'Y'       #OPEN1  1                       089189            MD054955
     C**********           END                                            089189            MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SROPE2   : Open files in QTEMP                               *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********2        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SROPE2'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070OPE2                                                             MD054955
      **********                                                                            MD054955
      **********les in this mode only                                                       MD054955
      **********                                                                            MD054955
     C***********#OPEN2    IFEQ *BLANKS                                   089189            MD054955
     C**********         OPEN      CGWPLAYO                                                 MD054955
     C**********         OPEN      CGW1LAYO                                                 MD054955
     C**********         OPEN      CGPDECPD                                                 MD054955
     C**********         OPEN      CGPASCPD                                                 MD054955
     C**********           MOVE 'Y'       #OPEN2  1                       089189            MD054955
     C**********           END                                            089189            MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRCLOS   : Close all work files                              *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********S        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRCLOS'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070CLOS                                                             MD054955
      **********                                                                            MD054955
      **********les in this mode only                                                       MD054955
      **********                                                                            MD054955
     C**********         CLOSE     CGWPRDE1                                                 MD054955
     C**********         CLOSE     CGWPRDE2                                                 MD054955
     C**********         CLOSE     CGWPLAYO                                                 MD054955
     C**********         CLOSE     CGW1LAYO                                                 MD054955
     C**********         CLOSE     CGPDECPD                                                 MD054955
     C**********         CLOSE     CGPASCPD                                                 MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRNGRP   : Find Next Group                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: SRPATH - Process Path                             *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********P        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRNGRP'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070NGRP                                                             MD054955
      **********                                                                            MD054955
      **********ise control code                                                            MD054955
      **********                                                                            MD054955
     C**********         MOVEL     *BLANKS       W0RTN                                      MD054955
     C**********         DEFINE    EPLEV1        ##GSET                                     MD054955
      **********                                                                            MD054955
      **********rst delimter                                                                MD054955
      **********                                                                            MD054955
     C**********         SCAN      I#PATH:Y#     X#                       90                MD054955
      **********                                                                            MD054955
      **********d find length                                                               MD054955
      **********                                                                            MD054955
     C**********         IFEQ      '1'                                                      MD054955
      **********                                                                            MD054955
     C**********         SUB       Y#            Z#                5 0                      MD054955
     C**********         SUBST(P)  I#PATH:Y#     ##GSET                                     MD054955
      **********                                                                            MD054955
      **********to next free space                                                          MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Y#                                         MD054955
     C**********         ELSE                                                               MD054955
      **********                                                                            MD054955
      **********ng fixed length of six                                                      MD054955
      **********                                                                            MD054955
     C**********         SUBST     I#PATH:Y#     ##GSET                                     MD054955
     C**********         MOVEL     'CGD1087'     W0RTN             7                        MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********P        TAG                                                                MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRADDP   : Add Path                                          *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: SRPATH - Process Path                             *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********P        BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRADDP'      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********or subroutine                                                               MD054955
      **********                                                                            MD054955
     C**********YSRC,CG1070ADDP                                                             MD054955
      **********                                                                            MD054955
      **********ard Group Set use name                                                      MD054955
      **********                                                                            MD054955
     C**********T        IFEQ      'SYSTEM'                                                 MD054955
     C**********         MOVEL     ##GSET        EPPATH                                     MD054955
     C**********         ELSE                                                               MD054955
      **********                                                                            MD054955
      ********** name                                                                       MD054955
      **********                                                                            MD054955
     C**********RA       DEFINE                  CGDTA                                      MD054955
     C**********         IN        CGDTA                                                    MD054955
     C**********         MOVEL     DAPATH        ##PATH            6 0                      MD054955
     C**********         ADD       1             ##PATH                                     MD054955
     C**********         MOVEL     ##PATH        EPPATH                                     MD054955
     C**********         MOVEL     ##PATH        DAPATH                                     MD054955
     C**********         OUT       CGDTA                                                    MD054955
      **********                                                                            MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********extra fields and write record                                               MD054955
      **********                                                                            MD054955
     C**********         MOVEL     'D'           EPRECI                         Record IdentMD054955
     C**********         MOVEL     ##JOB         EPAJOB                         Job name    MD054955
     C**********         MOVEL     ##USR         EPAUSR                         User name   MD054955
     C**********         TIME                    EPATIM                         Action Time MD054955
     C**********         MOVEL     WUMRDT        EPARDT                         Action Date MD054955
     C**********         MOVEL     'I'           EPAACT                         Action Type MD054955
     C**********         Z-ADD     WURDNB        EPRDNB                         Run day numbMD054955
      **********                                                                            MD054955
      **********d exists DB Error                                                           MD054955
      **********                                                                            MD054955
      **********                                                                            MD054955
      **********r duplicate primary key                                                     MD054955
      **********                                                                            MD054955
     C**********H        SETLL     @PATHL0                                90    *           MD054955
     C**********         IFEQ      '1'                                                      MD054955
     C**********         MOVEL     'CGPATHL0'    W0FILE                                     MD054955
     C**********         MOVEL     I#PATH        W0KEY                          ************MD054955
     C**********         Z-ADD     3             W0ERNB                         * DB ERROR 0MD054955
     C**********         MOVEL     'CGD1089'     W0MSGD                         ************MD054955
     C**********         MOVEL     'CGUSRMSG'    W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
     C**********         ELSE                                                               MD054955
     C**********         WRITE     @PATHL0                                                  MD054955
     C**********         END                                                                MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********P        TAG                                                                MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT                                                                                MD054955
      *****************************************************************                     MD054955
      *                                                               *                     MD054955
      *  SRACT    : Undefined action - error                          *                     MD054955
      *                                                               *                     MD054955
      *  CALLED BY: Main Processing                                   *                     MD054955
      *                                                               *                     MD054955
      *  CALLS    : SRERR   - report error and close down program     *                     MD054955
      *                                                               *                     MD054955
      *****************************************************************                     MD054955
     C**********         BEGSR                                                              MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         ADD       1             Q                                          MD054955
     C**********         MOVEL     'SRACT '      @STK(Q)                                    MD054955
      **********                                                                            MD054955
      **********e error undefined action                                                    MD054955
      **********                                                                            MD054955
     C**********         MOVEL     '*ACTION '    W0FILE                         ************MD054955
     C**********         MOVEL     W0ACT         W0KEY                          * DB ERROR 0MD054955
     C**********         Z-ADD     4             W0ERNB                         ************MD054955
     C**********         MOVEL     'MEM5006'     W0MSGD                                     MD054955
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD054955
     C**********         EXSR      SRERR                                                    MD054955
      **********                                                                            MD054955
      **********subroutine stack name                                                       MD054955
      **********                                                                            MD054955
     C**********         TAG                                                                MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                    MD054955
     C**********         SUB       1             Q                                          MD054955
      **********                                                                            MD054955
     C**********         ENDSR                                                              MD054955
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG1070INIT
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *
      * Cpysrc Templates Initialise Program C-spec
      *
     C/COPY WNCPYSRC,CG1000DCPG
     C/EJECT
      *
      * File and Program Error Processing
      *
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C/EJECT
      *
      * Cpysrc Templates Initialise Program O-spec
      *
     O/COPY WNCPYSRC,CG1000DOPG
**  CPY@
(c) Finastra International Limited 2001
