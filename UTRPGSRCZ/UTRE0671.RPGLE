     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to change incorrect Int. Type/Subtype')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  UTRE0671 - Utility to change incorrect Int. Type/Stype       *
      *                                                               *
      *  Function:  This program will Audit/Update retail accounts w/ *
      *             incorrect int. type/stype found in pf/REHPOSR1 and*
      *             update RE history files accordingly, based on     *
      *             int. details found in REIACD.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD023799A          Date 09Jan13               *
      *                 AR1055719 *CREATE  Date 26Nov13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023799A - Amended the utility so that those account inser- *
      *              ted and those account with rate movement on      *
      *              rundate will not be processed.                   *
      *  AR1055719 - Wrong Retail Interest Rate. Created a utility    *
      *              that will update pf/REHPOSRn with the correct    *
      *              interest rate details based on pf/REIACD.        *
      *              (Child: AR1055720)                               *
      *            - Applied for MD023799                             *
      *                                                               *
      *****************************************************************
     FREIAC     IF   E           K DISK    PREFIX(RP)
     F                                     IGNORE(REIACAF)
     F                                     IGNORE(REIACZF)
     FACCBR     IF   E           K DISK    PREFIX(AC)
     FREINT     IF   E           K DISK
     F                                     IGNORE(REINTAF)
     F                                     IGNORE(REINTZF)
     FSDBSRTL1  IF   E           K DISK
     FREHRDJ    IF   E           K DISK    PREFIX(DR)
     FREHRCJ    IF   E           K DISK    PREFIX(CR)
     FREHPOSRL  UF A E           K DISK    PREFIX(RR)
     FREHISBL   UF   E           K DISK    RENAME(REHISPPF:REHISPBF)
     F                                     PREFIX(B_)
     FREHISL    UF   E           K DISK    PREFIX(RS)
     F                                     IGNORE(REHISPMF)
     FUTRE0671P1O    E             PRINTER OFLIND(*IN80)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   80    - Printer overflow on UTRE0671P1                      *
      *   97    - Audit/Update mode                                   *
      *   99/LR - EOF for LF/UTRE0671L1                               *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structure for Bank Details
      *SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      * DATA STRUCTURE FOR Base Rate DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
      ** Declared Variables
      *
     D PRINTP          S              2  0
     D PRINST          S              5  0
     D KDRCR           S              1  0
     D KRSEQ           S              1
     D WkDATE          S              5P 0
     D WkVALD          S              5P 0
     D WWBRAT          S             11P 7
 
      *  Data Structure for Rate 2
     D STRAT2          DS
     D  SRAT2                  1     36
     D  RAT2A                  1      6P 7
     D  RAT2B                  7     12P 7
     D  RAT2C                 13     18P 7
     D  RAT2D                 19     24P 7
     D  RAT2E                 25     30P 7
     D  RAT2F                 31     36P 7
 
      *  Data Structure for Bal  2
     D STBAL2          DS
     D  SBAL2                  1     48
     D  BAL2A                  1      8P 0
     D  BAL2B                  9     16P 0
     D  BAL2C                 17     24P 0
     D  BAL2D                 25     32P 0
     D  BAL2E                 33     40P 0
     D  BAL2F                 41     48P 0
 
      *  Data Structure for Rate 3
     D STRAT3          DS
     D  RAT3                   1     30
     D  RAT3A                  1      6P 7
     D  RAT3B                  7     12P 7
     D  RAT3C                 13     18P 7
     D  RAT3D                 19     24P 7
     D  RAT3E                 25     30P 7
 
      *  Data Structure for Bal  3
     D STBAL3          DS
     D  BAL3                   1     40
     D  BAL3A                  1      8P 0
     D  BAL3B                  9     16P 0
     D  BAL3C                 17     24P 0
     D  BAL3D                 25     32P 0
     D  BAL3E                 33     40P 0
 
      *  Data Structure for Bal  2/3
     D WkBAL3          DS
     D  WBal3                  1     40
     D  WBal3A                 1      8P 0
     D  WBal3B                 9     16P 0
     D  WBal3C                17     24P 0
     D  WBal3D                25     32P 0
     D  WBal3E                33     40P 0
 
     D LDA             DS           256
      *
      ** Define LDA
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D RUNDT           DS            13
      *
      ** RUNDAT data structure to pick up system rundate.
      *
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
 
     D KEY             DS            12
     D BLANC                   1      1
     D TYPE                    2      3
     D SBTYPE                  4      8
     D CURR                    9     11
     D D                      12     12
 
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRMAIN - Main Processing                                     *
      *  SRMODE - Process Audit/Update mode                           *
      *  *PSSR  - Error Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    @MODE             1
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Process main processing
      *
     C                   EXSR      SRMAIN
 
     C                   IF        *IN80 = *ON
     C                   WRITE     HEAD1
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
     C                   IF        TRAIL = 0
     C                   WRITE     NODETAIL
     C                   ELSE
     C                   WRITE     TOTAL
     C                   ENDIF
      *
      ** End program.
      *
     C                   SETON                                        LR
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial processing                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END
      *
      ** Keylist for REHPOSR1
      *
     C     BRKey         KLIST
     C                   KFLD                    RPCCY
     C                   KFLD                    @BSRC
     C     KEY1          KLIST
     C                   KFLD                    RPBRCA
     C                   KFLD                    RPCNUM
     C                   KFLD                    RPCCY
     C                   KFLD                    RPACOD
     C                   KFLD                    RPACSQ
 
     C     RRKEY         KLIST
     C                   KFLD                    RPBRCA
     C                   KFLD                    RPCNUM
     C                   KFLD                    RPCCY
     C                   KFLD                    RPACOD
     C                   KFLD                    RPACSQ
     C                   KFLD                    WkDate
     C                   KFLD                    KDRCR
     C                   KFLD                    KRSEQ
 
     C     RSKEY         KLIST
     C                   KFLD                    RPBRCA
     C                   KFLD                    RPCNUM
     C                   KFLD                    RPCCY
     C                   KFLD                    RPACOD
     C                   KFLD                    RPACSQ
     C                   KFLD                    WkDate
 
      *
      ** Audit/Update Mode
      *
     C                   IF        @MODE = 'U'
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
      *
      ** Get RUND from DTAARA/RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDT
      *
      ** Write headers for reports.
      *
     C                   WRITE     HEAD1
      *
      ** Set up counters.
      *
     C                   EVAL      DBPGM = 'UTRE0671'
     C                   Z-ADD     0             TRAIL
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main processing                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : SRMODE                                            *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
 
     C                   READ      REIAC
     C                   DOW       NOT(%EOF(REIAC))
     C                   IF        RPRECI = 'D'                                            MD023799A
      *                                                                                    MD023799A
      ** Ignore if account was inserted or updated on rundate.                             MD023799A
      ** (i.e. On-line DR/CR rate chg value date equal to rundate)                         MD023799A
      *                                                                                    MD023799A
     C     KEY1          CHAIN     ACCBR                                                   MD023799A
     C                   IF        NOT %FOUND(ACCBR)                                       MD023799A
     C                   MOVEL     RPCNUM        DBKEY                                     MD023799A
     C                   MOVEL     'ACCBR'       DBFILE                                    MD023799A
     C                   MOVEL     '003'         DBASE                                     MD023799A
     C                   EXSR      *PSSR                                                   MD023799A
     C                   ENDIF                                                             MD023799A
      *                                                                                    MD023799A
     C     ACORED        IFNE      BJRDNB                                                  MD023799A
     C     ACOLDR        IFNE      BJRDNB                                                  MD023799A
      *                                                                                    MD023799A
     C**********         IF        RPRECI = 'D'                                            MD023799A
 
     C     RPDICT        IFNE      *Zeros
     C                   EVAL      KDRCR = 0
     C     KEY1          SETGT     REHRDJ
     C**********         READP     REHRDJ                                                  MD023799A
     C     KEY1          READPE    REHRDJ                                 54               MD023799A
     C     *IN54         IFEQ      '0'                                                     MD023799A
     C                   IF        (RPDICT <> DRINTP) or (RPDCST <> DRINST)
 
     C                   EXSR      GetRTDate
     C     UPDOK         IFEQ      'Y'                                                     MD023799A
     C                   EXSR      PrintDetl
     C                   IF        *IN97 = *On
     C                   EXSR      UpdRatePF
     C                   EXSR      UpdHdRec
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
 
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
 
     C     ACOLCR        IFNE      BJRDNB                                                  MD023799A
     C     RPCICT        IFNE      *Zeros
     C                   EVAL      KDRCR = 1
     C     KEY1          SETGT     REHRCJ
     C**********         READP     REHRCJ                                                  MD023799A
     C     KEY1          READPE    REHRCJ                                 54               MD023799A
     C     *IN54         IFEQ      '0'                                                     MD023799A
     C                   IF        (RPCICT <> CRINTP) or (RPCCST <> CRINST)
 
     C                   EXSR      GetRTDate
     C     UPDOK         IFEQ      'Y'                                                     MD023799A
     C                   EXSR      PrintDetl
     C                   IF        *IN97 = *On
     C                   EXSR      UpdRatePF
     C                   EXSR      UpdHdRec
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
 
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                             MD023799A
     C                   ENDIF                                                             MD023799A
     C                   READ      REIAC
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  GetRTDate - Determine start date of DR/CR rate change        *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     GetRTDate     BEGSR
 
     C     KEY1          CHAIN     ACCBR
     C                   IF        NOT %FOUND(ACCBR)
     C                   MOVEL     RPCNUM        DBKEY
     C                   MOVEL     'ACCBR'       DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                    MD023799A
      ** Check if account was inserted or updated on rundate.                              MD023799A
      *                                                                                    MD023799A
     C     KDRCR         IFEQ      0                                                       MD023799A
      *                                                                                    MD023799A
     C     ACOLDR        IFNE      0                                                       MD023799A
     C     ACOLDR        ANDNE     ACDRCD                                                  MD023799A
     C                   MOVE      'N'           UPDOK             1                       MD023799A
     C                   ELSE                                                              MD023799A
     C                   MOVE      'Y'           UPDOK                                     MD023799A
     C                   ENDIF                                                             MD023799A
      *                                                                                    MD023799A
     C                   ELSE                                                              MD023799A
      *                                                                                    MD023799A
     C     ACOLCR        IFNE      0                                                       MD023799A
     C     ACOLCR        ANDNE     ACCRCD                                                  MD023799A
     C                   MOVE      'N'           UPDOK             1                       MD023799A
     C                   ELSE                                                              MD023799A
     C                   MOVE      'Y'           UPDOK                                     MD023799A
     C                   ENDIF                                                             MD023799A
      *                                                                                    MD023799A
     C                   ENDIF                                                             MD023799A
 
     C     UPDOK         IFEQ      'Y'                                                     MD023799A
     C                   IF        KDRCR = 0
     C                   EVAL      PRINTP = DRINTP
     C                   EVAL      PRINST = DRINST
     C                   EVAL      WkDATE = ACDRCD
     C                   ELSE
     C                   EVAL      PRINTP = CRINTP
     C                   EVAL      PRINST = CRINST
     C                   EVAL      WkDATE = ACCRCD
     C                   ENDIF
 
     C                   EVAL      TRAIL = TRAIL + 1
     C                   ENDIF                                                             MD023799A
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  PrintDetl - Print account and rate details on report         *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     PrintDetl     BEGSR
 
     C                   IF        KDRCR = 0
     C                   EVAL      RPDRCR = 'DR'
     C                   EVAL      NWINTP = RPDICT
     C                   EVAL      NWSTYP = RPDCST
     C                   EVAL      RPACNO = DRACNO
     C                   ELSE
     C                   EVAL      RPDRCR = 'CR'
     C                   EVAL      NWINTP = RPCICT
     C                   EVAL      NWSTYP = RPCCST
     C                   EVAL      RPACNO = CRACNO
     C                   ENDIF
     C                   EVAL      ZDAYNO = WkDate
     C                   EXSR      FmtDate
     C                   EVAL      RPHISD = ZADATE
     C                   EVAL      CUINTP = PRINTP
     C                   EVAL      CUSTYP = PRINST
 
     C                   IF        *IN80 = *ON
     C                   WRITE     HEAD1
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  UpdRatePF - Update REHPOSR1/2/3 files with the correct rate  *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     UpdRatePF     BEGSR
     C                   DUMP
     C                   Exsr      SR_REINTD
 
     C                   EVAL      WWBRAT = *ZEROS
     C     BRT           IFNE      *ZEROS
     C                   MOVE      BRT           @BSRC             2
     C     BRKey         CHAIN     SDBSRTL1
     C                   IF        NOT %FOUND(SDBSRTL1)
     C                   MOVEL     @BSRC         DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WWBRAT = BANBRT
     C                   ENDIF
 
     C                   EVAL      KRSEQ = '1'
     C     RRKEY         CHAIN     REHPOS1F                           51
     C                   IF        *IN51 = *OFF
     C                   EVAL      RRINTP = NWINTP
     C                   EVAL      RRINST = NWSTYP
     C                   EVAL      RRBRT = BRT
     C                   UPDATE    REHPOS1F
 
     C                   EVAL      KRSEQ = '2'
     C     RRKEY         CHAIN     REHPOS2F                           52
     C                   IF        *IN52 = *OFF
     C                   EVAL      RRINTH = INTH
     C                   EVAL      STBAL2 = BAL2
     C                   EVAL      STRAT2 = RAT2
     C                   ADD       WWBRAT        RAT2A
     C                   IF        BAL2B<>*ZERO
     C                   ADD       WWBRAT        RAT2B
     C                   ENDIF
     C                   IF        BAL2C<>*ZERO
     C                   ADD       WWBRAT        RAT2C
     C                   ENDIF
     C                   IF        BAL2D<>*ZERO
     C                   ADD       WWBRAT        RAT2D
     C                   ENDIF
     C                   IF        BAL2E<>*ZERO
     C                   ADD       WWBRAT        RAT2E
     C                   ENDIF
     C                   IF        BAL2F<>*ZERO
     C                   ADD       WWBRAT        RAT2F
     C                   ENDIF
     C                   EVAL      RRBAL2 = STBAL2
     C                   EVAL      RRRAT2 = STRAT2
     C                   EVALR     WkBAL3 = BAL2                                          BUG8947
     C                   IF        WBal3A = *ZEROS
     C                   EVAL      RRCONI = *BLANKS
     C                   ENDIF
     C                   UPDATE    REHPOS2F
 
     C                   EVAL      KRSEQ = '3'
     C     RRKEY         CHAIN     REHPOS3F                           53
     C                   IF        WBal3A = *ZEROS
     C                   IF        *IN53 = *OFF
     C                   DELETE    REHPOS3F
     C                   ENDIF
     C                   ELSE
     C                   EVALR     STBAL3 = BAL2
     C                   EVALR     STRAT3 = RAT2
     C                   IF        BAL3A<>*ZERO
     C                   ADD       WWBRAT        RAT3A
     C                   ENDIF
     C                   IF        BAL3B<>*ZERO
     C                   ADD       WWBRAT        RAT3B
     C                   ENDIF
     C                   IF        BAL3C<>*ZERO
     C                   ADD       WWBRAT        RAT3C
     C                   ENDIF
     C                   IF        BAL3D<>*ZERO
     C                   ADD       WWBRAT        RAT3D
     C                   ENDIF
     C                   IF        BAL3E<>*ZERO
     C                   ADD       WWBRAT        RAT3E
     C                   ENDIF
     C                   EVAL      RRBAL3 = STBAL3
     C                   EVAL      RRRAT3 = STRAT3
     C                   IF        *IN53 = *OFF
     C                   UPDATE    REHPOS3F
     C                   ELSE
     C                   EVAL      RRRSEQ = '3'
     C                   EVAL      RRCONI = ' '
     C                   EVAL      RRZZ017 = *BLANKS
     C                   WRITE     REHPOS3F
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        (CUINTP <> NWINTP)
     C                   Exsr      UpdPostPF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  UpdPostPF - Update REHISPD/S w/ correct rate change details  *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     UpdPostPF     BEGSR
 
     C     RSKEY         SETLL     REHISL
     C     KEY1          READE     REHISL
     C                   DOW       NOT %EOF(REHISL)
     C                   IF        KDRCR = 0
     C                   EVAL      RSDICT = NWINTP
     C                   ELSE
     C                   EVAL      RSCICT = NWINTP
     C                   ENDIF
     C                   IF        RSRECI = 'S'
     C                   UPDATE    REHISPSF
     C                   ELSE
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C     KEY1          READE     REHISL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  UpdHdRec - Update Header/'B' record to recalculate interest  *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     UpdHdRec      BEGSR
 
     C     KEY1          CHAIN     REHISBL
 
     C                   IF        NOT %FOUND(REHISBL)
     C                   MOVEL     ACACNO        DBKEY
     C                   MOVEL     'REHISBL'     DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      B_ADTY = 'Y'
     C                   IF        B_VDTC > WkDATE
     C                   EVAL      B_VDTC = WkDATE
     C                   ENDIF
     C                   UPDATE    REHISPBF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SR_REINTD - Retrieve Int. Type details from pf/REINTD     e  *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SR_REINTD     BEGSR
 
     C                   MOVE      NWINTP        TYPE
     C                   MOVE      NWSTYP        SBTYPE
     C                   MOVE      RPCCY         CURR
     C                   MOVE      'D'           d
     C     KEY           CHAIN     REINT
     C                   IF        NOT %FOUND(REINT)
     C                   MOVEL     KEY           DBKEY
     C                   MOVEL     'REINT'       DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  FmtDate - Call to ZDATE2                                     *
      *                                                               *
      *  Called By: SR/PrintDetl                                      *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     FmtDate       BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine.                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
      ** Set on indicators to end the program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
