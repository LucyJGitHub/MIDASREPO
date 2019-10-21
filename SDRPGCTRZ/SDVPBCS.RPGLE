     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate private banking requested cust')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Private Bankings Validation   *
      *                                                               *
      *  SDVPBCS  - Validate Requested Customer Indicator             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 232543             Date 31Mar05               *
      *                 CGL031             Date 05Jul04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198158             Date 27Sep01               *
      *                 197191             Date 22Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 03Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation on Savings Income                          *
      *  198158 - Add validation on Account Officer: must be defined  *
      *           and have code 2 or 3.                               *
      *  197191 - Review behaviour of fields Valid Counterparty and   *
      *           Requested PB Customer                               *
      *  CPB002 - New PB Customer processing.                         *
      *  CAP034 - Conversion of SD inputs to modular structure        *
      *           to use as APIs                                      *
      *****************************************************************
      ** +--------------------------------------+                                             CGL031
      ** ¦ F-specs                              ¦                                             CGL031
      ** ¦ =======                              ¦                                             CGL031
      ** +--------------------------------------+                                             CGL031
                                                                                              CGL031
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL031
 
 
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
                                                                                              CGL031
      ** Externally described DS for SAR details                                              CGL031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     D DDCUSN          S              6A                                                      CGL031
                                                                                              CGL031
      ** Parameter declarations                                                               CGL031
     D PSARd           S              6A                                                      CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
                                                                                              CGL031
      ** Switchable Feature                                                                   CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                198158
      ** External data structure for Account Officer code                       198158
     D SDACOF        E DS                  EXTNAME(SDACOFPD)                    198158
      ** External data structure for access programs (long)                     198158
     D DSFDY         E DS                  EXTNAME(DSFDY)                       198158
 
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
     C                   EXSR      VREPB
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDREPBOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VREPB         BEGSR
 
      * Default Requested Customer value is 'N'
     C     DDREPB        IFEQ      ' '
     C                   EVAL      DDREPB = 'N'
     C                   ENDIF
 
      * Requested Customer value can only be 'Y' if Private Banking
      * Customer is 'N'
     C     DDREPB        IFEQ      'Y'
     C     DDPRBA        ANDNE     'N'
     C                   MOVE      'N'           DDREPBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)
     C                   MOVEL     'USR3861'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Requested PB Customer may only be 'Y' or 'N'
     C     DDREPB        IFNE      'Y'
     C     DDREPB        ANDNE     'N'
     C     DDREPBOK      ANDNE     'N'                                          197191
     C                   MOVE      'N'           DDREPBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)
     C                   MOVEL     'USR3864'     MsgIdXAr(Idx)
     C                   ENDIF
                                                                                CPB002
      * Requested PB Customer cannot be 'Y' if customer is                      CPB002
      * a Portfolio Management customer.                                        CPB002
     C     DDREPB        IFEQ      'Y'                                          CPB002
     C     PtfrCust      ANDEQ     'Y'                                          CPB002
     C     DDREPBOK      ANDNE     'N'                                          197191
     C                   MOVE      'N'           DDREPBOK                       CPB002
     C                   ADD       1             Idx                            CPB002
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)                 CPB002
     C                   MOVEL     'USR4590'     MsgIdXAr(Idx)                  CPB002
     C                   ENDIF                                                  CPB002
                                                                                CPB002
      * Requested PB Customer cannot be 'Y' if customer is                      CPB002
      * Account Officer is not setup                                            CPB002
     C     DDREPB        IFEQ      'Y'                                          CPB002
     C     DDACOC        ANDEQ     *Blanks                                      CPB002
     C     DDREPBOK      ANDNE     'N'                                          CPB002
     C                   MOVE      'N'           DDREPBOK                       CPB002
     C                   ADD       1             Idx                            CPB002
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)                 CPB002
     C                   MOVEL     'USR4591'     MsgIdXAr(Idx)                  CPB002
     C                   ELSE                                                   198158
     C     DDREPB        IFEQ      'Y'                                          198158
     C     DDACOC        ANDNE     *BLANKS                                      198158
     C     DDREPBOK      ANDNE     'N'                                          198158
                                                                                198158
     C                   CALL      'AOACOFR0'                                   198158
     C                   PARM      *BLANK        ARetcode          7            198158
     C                   PARM      '*KEY   '     AOption           7            198158
     C                   PARM                    DDACOC                         198158
     C     SDACOF        PARM      SDACOF        DSFDY                          198158
                                                                                198158
      * Account Officer must have code 2 or 3                                   198158
                                                                                198158
     C     AZACOT        IFEQ      2                                            198158
     C     AZACOT        OREQ      3                                            198158
     C                   ELSE                                                   198158
     C                   MOVE      'N'           DDREPBOK                       198158
     C                   ADD       1             Idx                            198158
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)                 198158
     C                   MOVEL     'USR4594'     MsgIdXAr(Idx)                  198158
     C                   ENDIF                                                  198158
     C                   ENDIF                                                  198158
     C                   ENDIF                                                  CPB002
                                                                                              CGL031
      ** If Taxation on Savings Income is on                                                  CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
      ** Requested PB Customer can be 'Y' only when the Joint Account                         CGL031
      ** Type is 'N' or 'I'.                                                                  CGL031
                                                                                              CGL031
     C     DDCUSN        CHAIN     SDACUSL1                           90                      CGL031
                                                                                              CGL031
      ** Else if found, do additional validation.                                             CGL031
                                                                                              CGL031
     C                   IF        *IN90 = *OFF                                               CGL031
     C                   IF        DDREPB = 'Y'                                               CGL031
     C                   IF        E5JATP <> 'N' AND                                          CGL031
     C                             E5JATP <> 'I'                                              CGL031
     C                                                                                        CGL031
     C                   MOVE      'N'           DDREPBOK                                     CGL031
     C                   ADD       1             Idx                                          CGL031
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)                               CGL031
     C                   MOVEL     'USR4714'     MsgIdXAr(Idx)                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
                                                                                197191
      * Requested PB Customer cannot be 'Y' if Valid Counterparty is'Y'         197191
     C     DDREPB        IFEQ      'Y'                                          197191
     C     DDCOUN        ANDEQ     'Y'                                          197191
     C     DDREPBOK      ANDNE     'N'                                          197191
     C                   MOVE      'N'           DDREPBOK                       197191
     C                   ADD       1             Idx                            197191
     C                   MOVEL     'DDREPB'      FldNamXAr(Idx)                 197191
     C                   MOVEL     'USR4593'     MsgIdXAr(Idx)                  197191
     C                   ENDIF                                                  197191
 
     C     ENDVAL        ENDSR
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
      ** Other parms
      *
      ** Private Banking Requested Customer
     C                   PARM                    DDREPB            1
      *
      ** Private Banking Customer
     C                   PARM                    DDPRBA            1
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust          1            CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC            2            CPB002
      *                                                                         197191
      ** Valid Counterparty                                                     197191
     C                   PARM                    DDCOUN            1            197191
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
                                                                                              CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Private Banking Requested Customer - OK
     C                   PARM                    DDREPBOK          1
                                                                                              CGL031
      ** Access SAR details file to determine if Taxation on Sav-                             CGL031
      ** ings Income is on.                                                                   CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARd                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     1             DBase                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
                                                                                              CGL031
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
