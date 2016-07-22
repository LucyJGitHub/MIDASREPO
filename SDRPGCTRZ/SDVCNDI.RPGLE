     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Country of Domicile')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCNDI   - Validate Country of Domicile                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG25531           Date 14Aug09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 26Apr99               *
      *                                    Date ddmmmyy               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG25531 - Incorrect EU tax calculation                      *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      *
     FSDCTRYL1  IF   E           K DISK
     F                                     RENAME(@A4REBR:COUNTRIES)
     FSDACUSL1  IF   E           K DISK                                                     BUG25531
      *
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
      ** External DS for Bank Details                                                       BUG25531
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                BUG25531

      ** DS for access programs - short data structure                                      BUG25531
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG25531
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                     BUG25531
     D DDCUSN          S              6A                                                    BUG25531
      *                                                                                     BUG25531
      ** Parameter for SDBANKPD                                                             BUG25531
     D WRtCd           S              7A                                                    BUG25531
     D WOptn           S              7A                                                    BUG25531

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

      *
      ** VALIDATION
      *
     C                   EXSR      COLCV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCOLCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Country of Domicile
      *****************************************************************
     C     COLCV         BEGSR

      * Country of domicile must be entered
     C     DDCOLC        IFEQ      *BLANK
     C                   MOVE      'N'           DDCOLCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCOLC'      FldNamXAr(Idx)
     C                   MOVEL     'USR0220'     MsgIdXAr(Idx)
     C                   ENDIF

      * and must be on file
     C     DDCOLC        IFNE      *BLANK
     C     DDCOLC        CHAIN     COUNTRIES                          90

     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDCOLCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCOLC'      FldNamXAr(Idx)
     C                   MOVEL     'USR0067'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ENDIF
      *
      ** When changing customer from resident to non-resident, make sure that               BUG25531
      ** Federal State Code in Additional Customer Details Maintenance is blank.            BUG25531
      *                                                                                     BUG25531
     C     DDCUSN        CHAIN     SDACUSL1                                                 BUG25531
     C                   IF        %FOUND(SDACUSL1)                                         BUG25531
     C                             AND DDCOLC <> BJCNCD                                     BUG25531
     C                             AND E5STCD <> *BLANKS                                    BUG25531
     C                   MOVE      'N'           DDCOLCOK                                   BUG25531
     C                   ADD       1             Idx                                        BUG25531
     C                   MOVEL     'DDCOLC'      FldNamXAr(Idx)                             BUG25531
     C                   MOVEL     'USR8436'     MsgIdXAr(Idx)                              BUG25531
     C                   ENDIF                                                              BUG25531
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
     C                   PARM                    RetCodeOut
      *
      ** Country of Domicile (2A)
     C                   PARM                    DDCOLC            2
     C                   PARM                    DDCUSN                                     BUG25531
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country of Domicile - OK
     C                   PARM                    DDCOLCOK          1
      *                                                                                     BUG25531
      ** Retrieving the bank details                                                        BUG25531
      *                                                                                     BUG25531
     C                   CALL      'AOBANKR0'                                               BUG25531
     C                   PARM      '*MSG   '     WRtCd                                      BUG25531
     C                   PARM      '*FIRST '     WOptn                                      BUG25531
     C     SDBANK        PARM      SDBANK        DSFDY                                      BUG25531
      *
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
(c) Misys International Banking Systems Ltd. 2001
