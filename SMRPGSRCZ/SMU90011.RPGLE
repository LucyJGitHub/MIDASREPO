     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility for MD-60037')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  SMU90011 - Utility for MD-60037                              *
      *                                                               *
      *  Function:  This program deletes Stamp Tax History records of *
      *             non-existing accounts.                            *
      *                                                               *
      *  Called By: SMUC90011 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060037 *CREATE   Date 25May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060037 - Delete record in SDSTMDPD if the account no longer*
      *             exist in ACCNTAB.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
     FSDSTMDLJ  UF   E           K DISK    INFSR(*PSSR)
     FSMU90011P1O    E             PRINTER OFLIND(*IN82)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   80 -  EOF in SDSTMDLJ                                       *
      *   81 -  Chain to Accounts file                                *
      *   82 -  Overflow SMU90011P1                                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Rundate data structure
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Bank Details.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Data structure for Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** ZDATE2 parameters
      *
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initial printing of report header
      *
     C                   WRITE     HEADER1
      *
      ** Read SDSTMDLJ
      *
     C     *LOVAL        SETLL     SDSTMDLJ
     C                   READ      SDSTMDLJ                               80
     C                   IF        *IN80 = *OFF
     C                   MOVE      T2CCY         L_CCY
     C                   EXSR      ACSCCY
     C                   ENDIF
      *
     C                   DOW       *IN80 = '0'
     C     KSTMP         CHAIN     ACCNTL0                            84
      *
      ** Check if account still exist in ACCNTAB
      *
     C                   IF        *IN84 = *ON
      *
      ** Printer overflow checking
      *
     C                   IF        *IN82 = '1'
     C                   WRITE     HEADER1
     C                   EVAL      *IN82 = '0'
     C                   ENDIF
      *
      ** Populate printer file
      *
     C                   EVAL      PKEY  = T2KEY
     C                   EVAL      PBRCA = T2BRCA
     C                   EVAL      PCNUM = T2CNUM
     C                   EVAL      PCCY = T2CCY
     C                   EVAL      PACOD = T2ACOD
     C                   EVAL      PACSQ = T2ACSQ
      ** Tax Posted Date
     C                   EVAL      ZDAYNO = T2PSDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   EVAL      PPSDT = ZADATE
      ** Tax Value Date
     C                   EVAL      ZDAYNO = T2VALD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   EVAL      PVALD = ZADATE
      ** Tax In Stamp Tax Currency
     C                   Z-ADD     T2TASC        PTASC            15 0
      *
      ** Move Ave. Balance to output fieds for report
      *
     C   50              Z-ADD     PTASC         PTASC0
     C   51              Z-ADD     PTASC         PTASC1
     C   52              Z-ADD     PTASC         PTASC2
     C   53              Z-ADD     PTASC         PTASC3
     C     PTASC         COMP      0                                    54
      *
      ** Tax Rate
      *
     C                   Z-ADD     T2TXRT        PTXRT
      *
      ** Write details to printer file
      *
     C                   WRITE     DETAIL1
      *
      ** Accumulate records in error
      *
     C                   ADD       1             WRECER
     C                   IF        *IN16 = '1'
     C                   DELETE    SDSTMDLJ
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SDSTMDLJ                               80
      *
      ** If new currency, access currency file
      *
     C                   IF        L_CCY <> T2CCY
     C                   MOVE      T2CCY         L_CCY             3
     C                   EXSR      ACSCCY
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Write footer
      *
     C                   IF        WRECER = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   WRITE     TRAILER1
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Access Currency file                                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      T2CCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SMU90011'    DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     T2CCY         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEA     '0000'        *IN(50)
     C     A6NBDP        IFEQ      0
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C     A6NBDP        IFEQ      1
     C                   MOVE      '1'           *IN51
     C                   ENDIF
     C     A6NBDP        IFEQ      2
     C                   MOVE      '1'           *IN52
     C                   ENDIF
     C     A6NBDP        IFEQ      3
     C                   MOVE      '1'           *IN53
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     KSTMP         KLIST
     C                   KFLD                    T2CNUM
     C                   KFLD                    T2CCY
     C                   KFLD                    T2ACOD
     C                   KFLD                    T2ACSQ
     C                   KFLD                    T2BRCA
      *
      ** Check mode if AUDIT or UPDATE
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             WRECER            6 0
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'SMU90011'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2022
