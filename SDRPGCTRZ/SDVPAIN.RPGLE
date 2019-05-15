     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Parent Indicator and Number')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Date Module Customer Details Validation     *
      *                                                               *
      *  SDVPAIN  - Validate Parent Indicator and Parent Number       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 226364             Date 19Aug14               *
      *                 TI010338           Date 21May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG1986            Date 28Apr04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196149             Date 16Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *Create    Date 01Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  226364 - Allow parent customers to have open GL accounts.    *
      *           Applied fix 210778.                                 *
      *           Applied for MD021329.                               *
      *  TI010338 - Validation is expected when Parent Indicator is   *
      *             set to 'P' and TI tab is filled. Applied for      *
      *             MD026906.                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG1986 - System Generated Customer Number                   *
      *  196149 - If customer is TI, customer cannot be a parent.     *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      *
      * Midas SD Securities Clients
     FSDSECSL1  IF   E           K DISK
     F                                     RENAME(@BFREDQ:SECURITIES)
      *
      * Midas Futures & Options Clients Retrieval Index
     FSDFOCSL1  IF   E           K DISK
     F                                     RENAME(@BHRED1:FUTOPTS)
      *
      * Midas GL Account Master
     FACCNTAL2  IF   E           K DISK
     F                                     RENAME(@CNTAD9:ACCMASTER)
      *
      * Midas SD Customer Details
     FSDCUSTL1  IF   E           K DISK
     F                                     RENAME(@BBREBF:CUSTDETAIL)
      *
      * Midas SD Customer Details by Parent
     FSDCUSTL4  IF   E           K DISK
     F                                     RENAME(@CUSTFR:CUSTPARENT)
      *
      * Midas SD Live Customers
     FSDCUSTL5  IF   E           K DISK
     F                                     RENAME(@CUSTFT:LIVECUST)
      *
      * Midas SD Portfolio Lending Customer Details Retrieval
     FSDLBCSL1  IF   E           K DISK
     F                                     RENAME(@LBCSL1:PORTLENCUS)
 
      *****************************************************************
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        RecdFound
 
      ** comments
 
      *
      ** VALIDATION
      *
     C                   EXSR      PIPNV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDPAINOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C     DDPCNBOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Parent Indicator and Parent Number
      *****************************************************************
     C     PIPNV         BEGSR
 
      * If parent customer number entered, must be on file
     C     DDPCNB        IFNE      *BLANK
     C     DDPCNB        CHAIN     CUSTDETAIL                         90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDPCNBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCNB'      FldNamXAr(Idx)
     C                   MOVEL     'USR0081'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
 
 
      * If parent indicator is P
     C     DDPAIN        IFEQ      'P'
      *                                                                                     TI010338
      ** If action code is Insert                                                           TI010338
      *                                                                                     TI010338
     C     DDACTN        IFEQ      'I'                                                      TI010338
     C     DDTICS        ANDEQ     'Y'                                                      TI010338
     C                   MOVE      'N'           DDPAINOK                                   TI010338
     C                   ADD       1             Idx                                        TI010338
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)                             TI010338
     C                   MOVEL     'USR3960'     MsgIdXAr(Idx)                              TI010338
     C                   ENDIF                                                              TI010338
 
      * If action code is Amend
     C     DDACTN        IFEQ      'A'
 
      * If customer is on securities file, may not be parent
     C     DDCUSN        CHAIN     SECURITIES                         90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'N'           DDPAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1566'     MsgIdXAr(Idx)
     C                   END
 
      * If customer is on futures and options file, may not be parent
     C     DDCUSN        CHAIN     FUTOPTS                            90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'N'           DDPAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1567'     MsgIdXAr(Idx)
     C                   END
     C                   END
 
      * Parent customer number must be blank (highlight both fields)
     C     DDPCNB        IFNE      *BLANKS
     C                   MOVE      'N'           DDPAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0186'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDPCNBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCNB'      FldNamXAr(Idx)
     C                   MOVEL     'USR0186'     MsgIdXAr(Idx)
     C                   END
 
      * If customer on account master file
     C**********         Z-ADD     0             CUSNUMERIC        6 0                        CSD027
     C                   MOVE      *BLANKS       CUSNUMERIC        6                          CSD027
     C                   MOVE      DDCUSN        CUSNUMERIC
     C     CUSNUMERIC    CHAIN     ACCMASTER                          90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           RecdFound         1
     C                   ELSE
     C                   MOVE      'Y'           RecdFound
     C                   END
 
      **Error,*unless*account*closed*before*today**********************                       226364
     C*****RecdFound     IFEQ      'Y'                                                        226364
     C*****AJRECI        ANDNE     'D'                                                        226364
     C*****AJDACC        ANDLT     RDNB                                                       226364
     C**********         MOVE      *BLANK        RecdFound                                    226364
     C**********         END                                                                  226364
 
     C*****RecdFound     IFEQ      'Y'                                                        226364
     C**********         MOVE      'N'           DDPAINOK                                     226364
     C**********         ADD       1             Idx                                          226364
     C**********         MOVEL     'DDPAIN'      FldNamXAr(Idx)                               226364
     C**********         MOVEL     'USR0191'     MsgIdXAr(Idx)                                226364
     C**********         END                                                                  226364
 
      *                                                                                       196149
      ** If customer is TI, customer cannot be a parent.                                      196149
      *                                                                                       196149
     C**********         Z-ADD     0             CUSNUMERIC        6 0                 196149 CSD027
     C                   MOVE      *BLANKS       CUSNUMERIC        6                          CSD027
     C     DDCUSN        CHAIN     CUSTDETAIL                         90                      196149
     C     *IN90         IFEQ      '0'                                                        196149
     C*****BBTICS        ANDEQ     'Y'                                               196149 TI010338
     C     DDTICS        ANDEQ     'Y'                                                      TI010338
     C                   MOVE      'N'           DDPAINOK                                     196149
     C                   ADD       1             Idx                                          196149
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)                               196149
     C                   MOVEL     'USR3960'     MsgIdXAr(Idx)                                196149
     C                   ENDIF                                                                196149
 
 
      * Otherwise (i.e. parent indicator is not P)
     C                   ELSE
 
      * If parent indicator is blank
     C     DDPAIN        IFEQ      *BLANK
 
      * If parent customer number is not blank
     C     DDPCNB        IFNE      *BLANK
 
      * Parent must be a live customer
     C     DDPCNB        CHAIN     LIVECUST                           90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           RecdFound
     C                   ELSE
     C                   MOVE      'Y'           RecdFound
     C                   ENDIF
     C     RecdFound     IFEQ      'N'
     C                   MOVE      'N'           DDPCNBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCNB'      FldNamXAr(Idx)
     C                   MOVEL     'USR0507'     MsgIdXAr(Idx)
 
      * Otherwise (i.e. parent is a live customer)
     C                   ELSE
 
      * If parent indicator on file is P
     C     BBPAIN        IFEQ      'P'
 
      * If module Portfolio Lending is ON
     C     BGLMCR        IFEQ      'Y'
 
      * If customer is on portfolio lending file
     C     DDCUSN        CHAIN     PORTLENCUS                         90
 
     C     *IN90         IFEQ      '0'
 
      * Parent must be on portfolio lending file
     C     DDPCNB        CHAIN     PORTLENCUS                         90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDPCNBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCNB'      FldNamXAr(Idx)
     C                   MOVEL     'USR2639'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Otherwise error (i.e. parent indicator on file is not P)
     C                   ELSE
     C                   MOVE      'N'           DDPCNBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCNB'      FldNamXAr(Idx)
     C                   MOVEL     'USR1084'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      * If customer is on parent customer file, error
     C                   MOVE      *BLANKS       RecdFound
      *                                                                                      BUG1986
     C     DDCUSN        IFNE      *BLANK                                                    BUG1986
      *                                                                                      BUG1986
     C     DDCUSN        CHAIN     CUSTPARENT                         90
     C     *IN90         IFEQ      '0'
     C     *IN90         DOWEQ     '0'
     C     BBTYLC        IFNE      'D'
     C                   MOVE      'Y'           RecdFound
     C                   ENDIF
     C     DDCUSN        READE     CUSTPARENT                             90
     C                   ENDDO
     C                   ENDIF
 
     C     RecdFound     IFEQ      'Y'
     C                   MOVE      'N'           DDPAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR1085'     MsgIdXAr(Idx)
     C                   END
      *                                                                                      BUG1986
     C                   ENDIF                                                               BUG1986
      *                                                                                      BUG1986
 
      * Otherwise error (i.e. parent indicator is not P and not blank)
     C                   ELSE
 
     C                   MOVE      'N'           DDPAINOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPAIN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0993'     MsgIdXAr(Idx)
     C                   END
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Action Code (1A)
      ** Parent Indicator (1A)
      ** Parent Customer Number (6A)
      ** Customer Number (6A)
      ** Runday Number (5P,0)
      ** Portfolio Lending (1A)
      ** TI Customer Flag (1A)                                                              TI010338
      **
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDPAIN            1
     C                   PARM                    DDPCNB            6
     C                   PARM                    DDCUSN            6
     C                   PARM                    RDNB              5 0
     C                   PARM                    BGLMCR            1
     C                   PARM                    DDTICS            1                        TI010338
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Parent Indicator - OK
     C                   PARM                    DDPAINOK          1
      *
      ** Parent Number - OK
     C                   PARM                    DDPCNBOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
