     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities amend checking for screen 3')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS3MD - Securities Amend Checking for Screen 3           *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            security details against those currently on        *
      *            file.  This program also checks whether all fields *
      *            amended are amendable, and if not, an error        *
      *            message will be sent to calling module.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 17May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204950             Date 16May02               *
      *                 204717             Date 16May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  204950 - Principal Paying agent, Guarantor, Weighting code   *
      *           and Nature of account have been added for Private   *
      *           Banking module and should be amendable !            *
      *  204717 - If Private Banking Module is ON,  (and not OFF)     *
      *            * Principal Paying agent is not amendable          *
      *            * Guarantor is not amendable                       *
      *            * Weighting Code is not amendable                  *
      *            * Nature of Account is not amendable               *
      *            * PB Instrument Type is not amendable              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(A)
      *
      ** Securities Screen 3 details retrieved from file
      ** - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities Screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
                                                                                              CGL031
      ** External DS for Switchable features details                                          CGL031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
                                                                                              CGL031
      ** First DS for Access programs - short data structure                                  CGL031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CGL031
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IDx             S              3P 0
                                                                                              CGL031
     D PRTCD           S              7A                                                      CGL031
     D POPTN           S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
     D CGL031          S              1A                                                      CGL031
      *
      ** Entry parameter fields
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D BGN4ST          S              1A
     D BGRKMG          S              1A
     D DDERPY          S              1A
     D DDNISS          S              1A
     D DDISA1          S             11A
     D WISA1           S             11P 0
     D WAISA2          S             11P 0
      *
      ** Parameters for module ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRCompare
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C                   IF        IDx > 0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C                   IF        IDx > 0 and PResetFld = 'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCompare - Routine to compare fields from file and the      *
      *              amended screen fields                            *
      *                                                               *
      *****************************************************************
     C     SRCompare     BEGSR
      *
      ** Issue Amount is not amendable.
      *
     C                   Z-ADD     *ZEROS        WISA1
     C                   Z-ADD     *ZEROS        WAISA2
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDISA1        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WISA1
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDISA2       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAISA2
      *
     C
     C                   IF        DDNISS <> 'Y' OR (BGRKMG = 'Y' AND
     C                             DDERPY = 'Y' AND WISA1 <> *ZERO)
     C                   IF        (WISA1 <> WAISA2) OR ZalignOK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDISA2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Issue Amount'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Issue Amount'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKISA2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** New Issue fields must not be amended if new issue flag is 'N'.
      *
     C                   IF        DDNISS <> 'Y'
      *                                                                                       CGL031
      ** Issue Date and price is amendable when CGL031 feature is                             CGL031
      ** switched on regardless of new issue field.                                           CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 <> 'Y'                                              CGL031
      *
      ** Issue Date is not amendable.
     C                   IF        ADDISSD <> DDISSD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDISSD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Issue Date'                            MD000091
     C                   EVAL      MsgDtaTmp = 'Issue Date'                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKISSD = 'N'
     C                   ENDIF
      *
      ** Issue Price is not amendable.
     C                   IF        ADDISSP <> DDISSP
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDISSP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Issue Price'                           MD000091
     C                   EVAL      MsgDtaTmp = 'Issue Price'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKISSP = 'N'
     C                   ENDIF
      *                                                                                       CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Lead Manager is not amendable.
     C                   IF        ADDLMGR <> DDLMGR
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDLMGR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Lead Manager'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Lead Manager'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKLMGR = 'N'
     C                   ENDIF
      *
      ** Total Underwritten not amendable.
     C                   IF        ADDTOTU <> DDTOTU
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDTOTU'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Total Underwritten'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Total Underwritten'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKTOTU = 'N'
     C                   ENDIF
      *
      ** Allocation Requested is not amendable.
     C                   IF        ADDALRQ <> DDALRQ
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDALRQ'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Allocation Requested'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Allocation Requested'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKALRQ = 'N'
     C                   ENDIF
      *
      ** Allocation Received is not amendable.
     C                   IF        ADDALRC <> DDALRC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDALRC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Allocation Received'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Allocation Received'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKALRC = 'N'
     C                   ENDIF
      *
      ** Management Fees Due is not amendable.
     C                   IF        ADDMGFD <> DDMGFD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMGFD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Management Fees Due'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Management Fees Due'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMGFD = 'N'
     C                   ENDIF
      *
      ** Management Fees Received is not amendable.
     C                   IF        ADDMGRC <> DDMGRC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMGRC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Management Fees Rcvd'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Management Fees Rcvd'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMGRC = 'N'
     C                   ENDIF
      *
      ** Underwriting Fees Due is not amendable.
     C                   IF        ADDUNFD <> DDUNFD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDUNFD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Underwriting Fees Due'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Underwriting Fees Due'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKUNFD = 'N'
     C                   ENDIF
      *
      ** Underwriting Fees Rcvd is not amendable.
     C                   IF        ADDUNFR <> DDUNFR
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDUNFR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Underwriting Fees Rcvd'                MD000091
     C                   EVAL      MsgDtaTmp = 'Underwriting Fees Rcvd'                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKUNFR = 'N'
     C                   ENDIF
      *
      ** Fee Currency is not amendable.
     C                   IF        ADDFECY <> DDFECY
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDFECY'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Fee Currency'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Fee Currency'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKFECY = 'N'
     C                   ENDIF
 
     C                   ENDIF
      **********                                                                              204717
      ***If*Private*Banking*is*not*installed,*check*if*the*following***                       204717
      ***fields*are*amended.*******************************************                       204717
      **********                                                                              204717
     C**********         IF        BGN4ST <> 'Y'                                              204717
     C                   IF        BGN4ST = 'Y'                                               204717
      **********                                                                              204950
      ***Principal*Paying*agent*is*not*amendable.**********************                       204950
     C**********         IF        ADDPPAG <> DDPPAG                                          204950
     C**********         EVAL      IDx = IDx + 1                                              204950
     C**********         EVAL      FldNameArr(IDx) = 'DDPPAG'                                 204950
     C**********         EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 204950
     C**********         EVAL      MsgDtaArr(IDx) = 'Principal Paying agent'                  204950
     C**********         EVAL      OKPPAG = 'N'                                               204950
     C**********         ENDIF                                                                204950
      **********                                                                              204950
      ***Guarantor*is*not*amendable.***********************************                       204950
     C**********         IF        ADDGUAR <> DDGUAR                                          204950
     C**********         EVAL      IDx = IDx + 1                                              204950
     C**********         EVAL      FldNameArr(IDx) = 'DDGUAR'                                 204950
     C**********         EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 204950
     C**********         EVAL      MsgDtaArr(IDx) = 'Guarantor'                               204950
     C**********         EVAL      OKGUAR = 'N'                                               204950
     C**********         ENDIF                                                                204950
      **********                                                                              204950
      ***Weighting*Code*is*not*amendable.******************************                       204950
     C**********         IF        ADDWEIC <> DDWEIC                                          204950
     C**********         EVAL      IDx = IDx + 1                                              204950
     C**********         EVAL      FldNameArr(IDx) = 'DDWEIC'                                 204950
     C**********         EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 204950
     C**********         EVAL      MsgDtaArr(IDx) = 'Weighting Code'                          204950
     C**********         EVAL      OKWEIC = 'N'                                               204950
     C**********         ENDIF                                                                204950
      **********                                                                              204950
      ***Nature*of*Account*is*not*amendable.***************************                       204950
     C**********         IF        ADDNATU <> DDNATU                                          204950
     C**********         EVAL      IDx = IDx + 1                                              204950
     C**********         EVAL      FldNameArr(IDx) = 'DDNATU'                                 204950
     C**********         EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 204950
     C**********         EVAL      MsgDtaArr(IDx) = 'Nature of Account'                       204950
     C**********         EVAL      OKNATU = 'N'                                               204950
     C**********         ENDIF                                                                204950
      *
      ** PB Instrument Type is not amendable.
     C                   IF        ADDPBIT <> DDPBIT
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDPBIT'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'PB Instrument Type'                    MD000091
     C                   EVAL      MsgDtaTmp = 'PB Instrument Type'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPBIT = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
     C     SRResetFlds   BEGSR
      *
      ** Issue Date.
      *
     C                   IF        OKISSD = 'N'
     C                   EVAL      ADDISSD = DDISSD
     C                   ENDIF
      *
      ** Issue Price.
      *
     C                   IF        OKISSP = 'N'
     C                   EVAL      ADDISSP = DDISSP
     C                   ENDIF
      *
      ** Issue Amount.
      *
     C                   IF        OKISA2 = 'N'
     C                   EVAL      ADDISA2 = DDISA1
     C                   ENDIF
      *
      ** Lead Manager.
      *
     C                   IF        OKLMGR = 'N'
     C                   EVAL      ADDLMGR = DDLMGR
     C                   ENDIF
      *
      ** Total Underwritten.
      *
     C                   IF        OKTOTU = 'N'
     C                   EVAL      ADDTOTU = DDTOTU
     C                   ENDIF
      *
      ** Allocation Requested.
      *
     C                   IF        OKALRQ = 'N'
     C                   EVAL      ADDALRQ = DDALRQ
     C                   ENDIF
      *
      ** Allocation Received
      *
     C                   IF        OKALRC = 'N'
     C                   EVAL      ADDALRC = DDALRC
     C                   ENDIF
      *
      ** Management Fees Due.
      *
     C                   IF        OKMGFD = 'N'
     C                   EVAL      ADDMGFD = DDMGFD
     C                   ENDIF
      *
      ** Management Fee Rcvd.
      *
     C                   IF        OKMGRC = 'N'
     C                   EVAL      ADDMGRC = DDMGRC
     C                   ENDIF
      *
      ** Underwriting Fees Due
      *
     C                   IF        OKUNFD = 'N'
     C                   EVAL      ADDUNFD = DDUNFD
     C                   ENDIF
      *
      ** Underwriting Fees Rcvd.
      *
     C                   IF        OKUNFR = 'N'
     C                   EVAL      ADDUNFR = DDUNFR
     C                   ENDIF
      *
      ** Fee Currency.
      *
     C                   IF        OKFECY = 'N'
     C                   EVAL      ADDFECY = DDFECY
     C                   ENDIF
      *
      ** Principal Paying agent.
      *
     C                   IF        OKPPAG = 'N'
     C                   EVAL      ADDPPAG = DDPPAG
     C                   ENDIF
      *
      ** Guarantor.
      *
     C                   IF        OKGUAR = 'N'
     C                   EVAL      ADDGUAR = DDGUAR
     C                   ENDIF
      *
      ** Weighting Code.
      *
     C                   IF        OKWEIC = 'N'
     C                   EVAL      ADDWEIC = DDWEIC
     C                   ENDIF
      *
      ** Nature of Account.
      *
     C                   IF        OKNATU = 'N'
     C                   EVAL      ADDNATU = DDNATU
     C                   ENDIF
      *
      ** PB Instrument Type.
      *
     C                   IF        OKPBIT = 'N'
     C                   EVAL      ADDPBIT = DDPBIT
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAmt - Align issue ammounts                                *
      *                                                               *
      *****************************************************************
 
     C     SRZAmt        BEGSR
 
     C                   Z-ADD     11            ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Early Repayments? - from 1st screen
      ** New Issue - from 1st screen
      ** Issue Amount 1 - from 2nd screen
     C                   PARM                    DDERPY
     C                   PARM                    DDNISS
     C                   PARM                    DDISA1
      *
      ** Securities Screen 3 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE3ScnFmt
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private Banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest Risk Management
     C                   PARM                    BGRKMG
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRTCD <> *BLANKS AND                                       CGL031
     C                             PRTCD <> '*NRF   '                                         CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '001'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
