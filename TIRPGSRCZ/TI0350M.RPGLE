     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI I/C Shadow posting of TI postings')           *
     F*****************************************************************
     F*                                                               *
     F*  Midas/TI Interface                                           *
     F*                                                               *
     F*  TI0350M - I/C Shadow Posting of TI Postings across Nostro    *
     F*           Accounts                                            *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 16Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 30Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 08May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 151068             Date 26Apr99               *
     F*                 CTI001    Create   DATE 23JUL97               *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  212558 - Change TIPOST DS and TIKEY as TIPOSTL0 key          *
     F*           definition has changed.                             *
     F*  CTI003 - Changes for Patch D.                                *
     F*           File changes not being committed.                   *
     F*  151068 - No narrative on shadow postings. If nothing passed  *
     F*           from TI then use the Deal Type and Deal Reference.  *
     F*  CTI001 - Midas/TI Interface (Phase 1)                        *
     F*                                                               *
     F*****************************************************************
     F*
     FTIPOSTL1  IF   E           K DISK
     F                                     RENAME(TIPOSTD0:@TIPSTL1)
     FTIPOSTL0  UF   E           K DISK    COMMIT
     F                                     RENAME(TIPOSTD0:@TIPSTL0)
     F*
     FPRONO     UF   E           K DISK    COMMIT
     F*
     FRSACMTPD  O    E           K DISK    COMMIT
     F/COPY WNCPYSRC,TI0350MF01
     F********************************************************************
     D*
     D ZHC             S              3    DIM(50)                              ZDATES S
     D*
     D*
     D CPYR@#          DS
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGH
     D*
     D                 DS
     D*     Move Prono balances & dates into arrays
     D  PNB                    1     40
     D  PRB                    1     40P 0
     D                                     DIM(5)                               PROJ. NO
     D  PND                   41     55
     D  PRD                   41     55P 0
     D                                     DIM(5) ASCEND                        PRONO BA
     D*
     D ACNERR          DS
     D*     ACCNT key for error reporting
     D**##CNUM**               1      6  0                                                    CSD027
     D  ##CNUM                 1      6A                                                      CSD027
     D  ##CCY                  7      9
     D***##ACOD*               10     13  0                                                   CGL029
     D***##ACSQ*               14     15  0                                                   CGL029
     D***##BRCA*               16     18                                                      CGL029
     D  ##ACOD                10     19  0                                                    CGL029
     D  ##ACSQ                20     21  0                                                    CGL029
     D  ##BRCA                22     24                                                       CGL029
     D*
     D TIPOST          DS
     D*     TIPOSTL0 key for error reporting
     D  TRANID                 1      4                                                       212558
     D  TIDLBR                 5      8                                                       212558
     D  TIEVRF                 9     25                                                       212558
     D  TISEQN                26     28  0                                                    212558
     D  TIVALD                29     35  0                                                    212558
     D**TIDLBR**               1      4                                                       212558
     D**TIDLTP**               5      7                                                       212558
     D**TIDLRF**               8     20                                                       212558
     D**TISEQN**              21     23  0                                                    212558
     D**TIVALD**              24     30  0                                                    212558
     D*
     D PROERR          DS
     D*     PRONO key for error reporting
     D  KCCY                   1      3
     D  KNNO                   4      5  0
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
     D LDA           E DS                  EXTNAME(LDA)
     D* Local Data Area to identify database errors
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D* Bank Details
     D*
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
     D* Account Details
     D*
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D* Nostro Details
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP205
     D  XLCD         E                     EXTFLD(LCD)                                        CAP205
     D* Switchable features data structure                                                    CAP205
     D*                                                                                       CAP205
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAP205
     D* First DS for Access programs, Short Data Structure                                    CAP205
     D*                                                                                       CAP205
     D TI0350        E DS                  EXTNAME(TI0350)
     D* Status data area
                                                                                              CGL029
     D W0ACCD          S             10A                                                      CGL029
                                                                                              CGL029
     D/COPY WNCPYSRC,TI0350MD01
     D*
     I********************************************************************
     I/EJECT
     I*****************************************************************
     I*
     IPRONOPNF
     I** Rename fields on PRONOPN
     I              CNUM                        PRCNUM
     I*
      /EJECT
     C********************************************************************
     C*
     C     *ENTRY        PLIST
     C                   PARM                    RTNCDE            1
     C*
     C*     Program initialisation
     C*
     C     FSTCAL        IFEQ      ' '
     C                   EXSR      INITSR
     C                   ENDIF
     C*
     C*     Transaction processing
     C*
     C                   SETOFF                                       10
     C     *LOVAL        SETLL     @TIPSTL1
     C                   READ      @TIPSTL1                               10
     C*
     C     *IN10         DOWEQ     '0'
     C*
     C** Move account keys to DS for error processing
     C**********         Z-ADD     CNUM          ##CNUM                                       CSD027
     C                   EVAL      ##CNUM = CNUM                                              CSD027
     C                   MOVE      CCY           ##CCY
     C                   Z-ADD     ACOD          ##ACOD
     C                   Z-ADD     ACSQ          ##ACSQ
     C                   MOVE      BRCA          ##BRCA
     C*
     C** Move numeric fields to alpha for call.
     C                   MOVE      CNUM          W0CNUM
     C                   MOVE      ACOD          W0ACCD
     C                   MOVE      ACSQ          W0ACSQ
     C*
     C* Get Account Details
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       W0RTCD
     C                   PARM      '*KEY    '    W0OPTN
     C                   PARM      *BLANK        W0RETL           10
     C                   PARM                    W0CNUM            6
     C                   PARM      CCY           W0CCY             3
     C**********         PARM                    W0ACCD            4                          CGL029
     C                   PARM                    W0ACCD                                       CGL029
     C                   PARM                    W0ACSQ            2
     C                   PARM      BRCA          W0BRCA            3
     C     SDACNT        PARM      SDACNT        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVEL(P)  'AOACCTR0'    DBFILE
     C                   MOVEL(P)  ACNERR        DBKEY                          ********
     C                   Z-ADD     02            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   END
     C*
     C                   MOVE      'N'           UPDIND            1
     C*
     C*  Process nostro account
     C                   IF        NONB <> 0
     C                   EXSR      NOSTRO
     C                   ENDIF
     C*
     C     UPDIND        IFEQ      'Y'
     C                   EXSR      RSACSR
     C     TIKEY         CHAIN     @TIPSTL0                           11
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVEL(P)  'TIPOSTL0'    DBFILE
     C                   MOVEL(P)  TIPOST        DBKEY                          ********
     C                   Z-ADD     03            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   ENDIF
     C*
     C                   MOVE      'SHP'         PSTS
     C                   UPDATE    @TIPSTL0                             11
     C*  Data base error if update fails
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVEL(P)  'TIPOSTL0'    DBFILE
     C                   MOVEL(P)  TIPOST        DBKEY                          ********
     C                   Z-ADD     03            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   ENDIF
     C*
     C                   COMMIT
     C                   ENDIF
     C*
     C* Check if STOP requested
     C                   IN        TI0350
     C     STATUS        IFEQ      'STOP'
     C                   MOVE      'S'           RTNCDE
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C*
     C                   READ      @TIPSTL1                               10
     C                   ENDDO
     C*
     C                   SETON                                        LR                      CTI003
     C                   RETURN
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:   NOSTRO                                         *
     C*     Prono processing - (Nostro)                                  *
     C*                                                                  *
     C********************************************************************
     C*
     C     NOSTRO        BEGSR
     C*
     C*     Access Prono record
     C                   EXSR      ACCPSR
     C*
     C                   Z-ADD     1             X                 1 0
     C*
     C** Move numeric fields to alpha for call.
     C                   MOVE      NONB          W0NONB
     C**
     C*    Access nostro details
     C**
     C                   CALL      'AONOSTR0'
     C                   PARM      '@MSG    '    W0RTCD
     C                   PARM      '*KEY'        W0OPTN
     C                   PARM      *BLANK        W0CNUM
     C                   PARM      CCY           W0CCY
     C                   PARM      *BLANK        W0ACCD
     C                   PARM      *BLANK        W0ACSQ
     C                   PARM                    W0NONB            2
     C                   PARM      *BLANK        W0BRCA
     C                   PARM      *BLANK        W0CSSN           10
     C                   PARM      *BLANK        W0PNOI            1
     C     SDNOST        PARM      SDNOST        DSSDY
     C*
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   Z-ADD     NONB          KNNO
     C                   MOVE(P)   'SDNOSTPD'    DBFILE
     C                   MOVEL(P)  PROERR        DBKEY                          ********
     C                   Z-ADD     05            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   ENDIF
     C*
     C     PRNERR        IFEQ      'N'                                          PRNERR =
     C**   Set up next working day for the currency CCY
     C                   Z-ADD     0             PNDS              5 0
     C     PRD(5)        ADD       1             InputDay          5 0
     C                   CALLB     'ZFWDT'
     C                   PARM                    InputDay          5 0
     C                   PARM      *ZERO         DaysFwd           2 0
     C     PNDS          PARM      *ZERO         OutputDay         5 0
     C                   PARM      CCY           Currency          3
     C                   PARM      A7NOSN        Location          3
     C*
     C*  Update all projected amounts which are between the value date
     C*  and the last projected date
     C     MTIVD         IFLT      PNDS
     C*
     C** Access the date 'equal to' or 'greater than' the value date
     C     MTIVD         LOOKUP    PRD(X)                             09  09
     C*
     C*     Array pointer would be positioned at:
     C*     Equal element     - When an *EQ is on
     C*     Greater than element - When *EQ is off and *HI is on
     C*     First element     - When both *EQ & *HI are off
     C*
     C     X             DOWLT     6
     C*
     C     TIDCIN        IFEQ      'D'
     C                   ADD       TIAMNT        PRB(X)
     C                   ENDIF
     C*
     C     TIDCIN        IFEQ      'C'
     C                   SUB       TIAMNT        PRB(X)
     C                   ENDIF
     C*
     C                   ADD       1             X
     C                   ENDDO
     C*
     C                   ENDIF
     C*
     C*     Prono record update
     C*
     C  N07              UPDATE    PRONOPNF                             08
     C*
     C*     Data base error if update fails
     C     *IN08         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVE(P)   'PRONO'       DBFILE
     C                   MOVEL(P)  PROERR        DBKEY                          ********
     C                   Z-ADD     06            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   ELSE
     C                   MOVE      'Y'           UPDIND
     C                   ENDIF
     C*
     C                   ENDIF                                                  PRNERR =
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:  ACCPSR                                          *
     C*     Access Prono record                                          *
     C*                                                                  *
     C********************************************************************
     C*
     C     ACCPSR        BEGSR
     C*
     C                   Z-ADD     *ZERO         INDEX             1 0
     C                   MOVE      CCY           KCCY
     C                   Z-ADD     NONB          KNNO
     C*
     C*     Try and retry to access record (five attempts)
     C*
     C     INDEX         DOWLT     5
     C*
     C     PROKEY        CHAIN     PRONOPNF                           0708
     C*
     C     *IN07         IFEQ      '1'
     C                   Z-ADD     5             INDEX
     C                   ELSE
     C     *IN08         IFEQ      '0'
     C                   Z-ADD     5             INDEX
     C                   ELSE
     C                   ADD       1             INDEX
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C*     Data base error if Prono record found -  but locked
     C     *IN08         CABEQ     '1'           PDBERR
     C*
     C*     If Prono record not found -  try for an unallocated nostro
     C     *IN07         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*
     C                   Z-ADD     *ZERO         INDEX
     C                   Z-ADD     *ZEROS        KNNO
     C*
     C*     Try and retry to access record (five attempts)
     C*     Set on *IN07 if record not found, or *IN08 if an error occurs
     C*
     C     INDEX         DOWLT     5
     C*
     C     PROKEY        CHAIN     PRONOPNF                           0708
     C*
     C*     If record not on file, exit loop
     C     *IN07         IFEQ      '1'
     C                   Z-ADD     5             INDEX
     C                   ELSE
     C*
     C*     If correct record found, exit loop
     C     *IN08         IFEQ      '0'
     C                   Z-ADD     5             INDEX
     C*
     C*     else retry
     C                   ELSE
     C                   ADD       1             INDEX
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C                   ENDIF
     C*
     C*  If none of the records is found this is a DB error, as the
     C*  the suspense nostro CCY/00 must exist
     C     *IN07         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVE(P)   'PRONO'       DBFILE
     C                   MOVEL(P)  PROERR        DBKEY                          ********
     C                   Z-ADD     07            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   ENDIF
     C*
     C     PDBERR        TAG
     C*     Set up Nostro Error flag if error occurred
     C                   MOVE      'N'           PRNERR            1
     C     *IN08         IFEQ      '1'
     C                   MOVE      'Y'           PRNERR
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*                                                                  *
     C*     RSACSR SR     SUB-ROUTINE                                    *
     C*     Shadow postings to RSACMTPD                                  *
     C*                                                                  *
     C********************************************************************
     C*
     C     RSACSR        BEGSR
     C*
     C*     For unallocated nostros initialise account key
     C     KNNO          IFEQ      *ZEROS
     C**********         Z-ADD     *ZEROS        CUSN                                         CSD027
     C                   EVAL      CUSN = *BLANKS                                             CSD027
     C                   Z-ADD     *ZEROS        ACDE
     C                   Z-ADD     *ZEROS        ASNC
     C                   MOVE      *BLANKS       BRCA
     C                   ELSE
     C**********         Z-ADD     CNUM          CUSN                           Customer      CSD027
     C                   EVAL      CUSN = CNUM                                  Customer      CSD027
     C                   Z-ADD     ACOD          ACDE                           Accnt Co
     C                   Z-ADD     ACSQ          ASNC                           Accnt Se
     C                   ENDIF
     C*
     C                   MOVE      CCY           CCYD                           Currency
     C                   Z-ADD     BJRDNB        PTDT                           Post Dat
     C                   Z-ADD     MTIVD         VUDT                           Value Da
     C                   MOVE      'TI'          TRYP                           Trans Ty
     C                   MOVE      *BLANK        NRTC                           Narr Cod
     C     TINAR1        IFEQ      *BLANKS                                      151068
     C                   MOVEL     TIDLTP        TINAR16          16            151068
     C                   MOVE      TIDLRF        TINAR16                        151068
     C                   MOVEL     TINAR16       NRTD                           151068
     C                   ELSE                                                   151068
     C                   MOVEL     TINAR1        NRTD                           Narr Des
     C                   END                                                    151068
     C                   MOVEL     *BLANK        TNMR                           Trans Nu
     C                   Z-ADD     0             CQNR                           Cheque N
     C                   Z-ADD     TIAMNT        MVAM                           Mvmt Amt
     C     TIDCIN        IFEQ      'D'
     C                   Z-ADD     *ZERO         DORC                           D/C Ind
     C                   ELSE
     C                   Z-ADD     1             DORC
     C                   ENDIF
     C                   MOVE      *BLANK        FUND
     C                   MOVE      *BLANK        TBID
     C                   MOVE      *BLANK        APBI
     C                   MOVE      *BLANK        PASS
      *                                                                                       CAP205
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'TI'          CMOD                                         CAP205
     C                   MOVEL     'S'           MTYP                                         CAP205
     C                   ENDIF                                                                CAP205
     C*
     C                   WRITE     RSACMTPO                             10
     C*
     C*     Data base error if write fails
     C     *IN10         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   Z-ADD     08            DBASE                          *DB ERRO
     C                   MOVE      'RSACMTPD'    DBFILE
     C                   MOVEL     'ON WRITE'    DBKEY
     C                   EXSR      ERRSR
     C                   ENDIF
     C/COPY WNCPYSRC,TI0350MC01
     C*
     C                   MOVE      ##BRCA        BRCA
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     INITSR SR     SUB-ROUTINE                                    *
     C*     Program initialisation                                       *
     C*                                                                  *
     C********************************************************************
     C*
     C     INITSR        BEGSR
     C*
     C                   MOVE      'N'           FSTCAL            1
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C* Define LDA
     C     *DTAARA       DEFINE                  LDA
     C*
     C* Define TI0350
     C     *DTAARA       DEFINE                  TI0350
     C*
     C     PROKEY        KLIST
     C                   KFLD                    KCCY
     C                   KFLD                    KNNO
     C*
     C     TIKEY         KLIST
     C                   KFLD                    TRANID                                       212558
     C                   KFLD                    TIDLBR
     C**********         KFLD                    TIDLTP                                       212558
     C**********         KFLD                    TIDLRF                                       212558
     C                   KFLD                    TIEVRF                                       212558
     C                   KFLD                    TISEQN
     C                   KFLD                    TIVALD
     C*
     C* Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM      '*FIRST  '    W0OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0350'      DBPGM
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*CALL'       DBKEY                          ********
     C                   Z-ADD     01            DBASE                          *DB ERRO
     C                   EXSR      ERRSR                                        ********
     C                   END
      *                                                                                       CAP205
      ** Access AOSARDR0 and check if CAP205 is installed                                     CAP205
      *                                                                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       W0RTCD                                       CAP205
     C                   PARM      '*VERIFY'     W0OPTN                                       CAP205
     C                   PARM      'CAP205'      W0SARD            6                          CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
      *                                                                                       CAP205
     C     W0RTCD        IFNE      *BLANKS                                                    CAP205
     C     W0RTCD        ANDNE     '*NRF    '                                                 CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   MOVE      'TI0370'      DBPGM                                        CAP205
     C                   MOVEL     'CAP205'      DBKEY                                        CAP205
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CAP205
     C                   Z-ADD     8             DBASE                          *DB ERROR 08  CAP205
     C                   EXSR      ERRSR                                        ************  CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP205
     C     W0RTCD        IFEQ      *BLANKS                                                    CAP205
     C                   MOVE      'Y'           CAP205            1                          CAP205
     C                   ELSE                                                                 CAP205
     C                   MOVE      'N'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP205
     C*
     C/COPY WNCPYSRC,TI0350MC02
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     ERRSR  SR     SUB-ROUTINE                                    *
     C*     Error routine                                                *
     C*                                                                  *
     C********************************************************************
     C*
     C     ERRSR         BEGSR
     C*
     C                   OUT       LDA
     C                   ROLBK
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   MOVE      'E'           RTNCDE
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
