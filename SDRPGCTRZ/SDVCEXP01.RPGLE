     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Certificate Expiry Date')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCEXP01 - Validate Certificate Expiry Date                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      *                 AR740196           Date 03Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26250           Date 30Sep09               *
      *                 BUG23780           Date 24Apr09               *
      *                 BUG23892           Date 06May09               *
      *                 BUG23658           Date 08Apr09               *
      *                 BUG23544           Date 25Mar09               *
      *                 BUG22912           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR740196  - Cannot enquire on deal for non-resident using    *
      *              Deals Enquiry (Child:AR740197)                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26250 - Customer Details By Country of Tax Maintenance    *
      *             Error. All cert. fields for all status should be  *
      *             optional.                                         *
      *  BUG23780 - No Validation on Cust Det Country of Tax          *
      *  BUG23892 - Certificate details should be mandatory if EU tax *
      *             status is 'S' and optional if it is 'T'           *
      *  BUG23658 - Certificate Expiry Date error should only         *
      *             check if record is changed                        *
      *  BUG23544 - Certificate Expiry Date should not be mandatory   *
      *             when you input EU Tax Status of 'T'               *
      *  BUG22912 - Threshold processing should be used if Exemption  *
      *             Certificate held                                  *
      *  CER048 - German Features - Taxes                             *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** Customer Details by Country of Tax                                                 BUG23658
     FSDACTXL1  IF   E           K DISK                                                     BUG23658
                                                                                            BUG23658
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
 
      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)
 
      ** Valid Customer Details                                                             AR740196
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)                               AR740196
     D                                     PREFIX(A_)                                       AR740196
      ** Valid Additional Customer Details                                                  AR740196
     D ValidCuad     E DS                  EXTNAME(SDVCUADPD)                               AR740196
     D                                     PREFIX(B_)                                       AR740196
      ** Screen Error Indicator
     D OKFlags       E DS                  EXTNAME(SDECCTXPD)
      *                                                                                       CER048
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG26250
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG26250
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Date Format Indicator
     D BJDFIN          S              1A
 
      ** Rundate
     D BJRDNB          S              5P 0
 
      ** ZDATE1 Parameters
     D ZDAYNO          S              5P 0
     D ErrorFlag       S              1A
 
      ** Work Variables
     D WExpDat         S              5P 0
     D ExDtChg         S              1A                                                    BUG23658
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      *                                                                                       CER048
      ** AOSARDR0 Parameters                                                                  CER048
      *                                                                                       CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D PKEY1           S             10A                                                    BUG26250
     D PKYST           S              7A                                                    BUG26250
     D WResi           S              1A                                                    BUG26250
      ** Mode of Operation                                                                  AR740196
     D PModeOfOp       S              6A                                                    AR740196
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
 
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
     C                   EVAL      WExpDat = 0
 
     C                   IF        PModeOfOp =  '*VU '                                      AR740196
     C                   EVAL      BBCOLC  = A_CUCOLC                                       AR740196
     C                   ENDIF                                                              AR740196
                                                                                            AR740196
     C                   IF        DDCEEX <> *BLANKS
 
      ** Validate that the expiry date only contains numbers
 
     C                   TESTN                   DDCEEX               9798
     C                   IF        *IN97 = *ON
     C                             Or *IN98 = *ON
      *                                                                                       CER048
     C**********         IF        CER048 = 'Y' AND                                  CER048 BUG23892
     C**********                   DDETXS <> 'S'                                     CER048 BUG22912
     C**********         IF        DDETXS <> 'S' AND                               BUG23892 BUG26250
     C**********                   DDETXS <> 'T'                                   BUG22912 BUG26250
     C**********         EVAL      OKCEEX = 'N'                                      CER048 BUG26250
     C**********         EVAL      Idx = Idx + 1                                     CER048 BUG26250
     C**********         EVAL      FldNamXAr(Idx) = 'DDETXS'                         CER048 BUG26250
     C**********         EVAL      MsgIdXAr (Idx) = 'USR8289'                        CER048 BUG26250
     C**********         GOTO      EMAIN                                             CER048 BUG26250
     C**********         ENDIF                                                       CER048 BUG26250
      *                                                                                       CER048
     C                   CALLB     'ZAVDATE'
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDCEEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO
     C                   ENDIF
 
      ** Error if value date is not numeric or is an invalid date
 
     C                   IF        *IN97 = *OFF
     C                             And *IN98 = *OFF
     C                             Or RetCodeOut = 'Error'
     C                   EVAL      OKCEEX = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDCEEX'      FldNamXAr(Idx)
     C                   MOVEL     'USR4784'     MsgIdXAr(Idx)
     C                   MOVE      *Blanks       MsgDtaXAr(Idx)
 
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     'DDMMYY'      MsgDtaXAr(Idx)
     C                   ELSE
     C                   MOVEL     'MMDDYY'      MsgDtaXAr(Idx)
     C                   ENDIF
     C                   GOTO      EMAIN
     C                   ENDIF
 
     C                   Z-ADD     ZDAYNO        WExpDat
 
      ** Date must be earlier than the current date
 
      *                                                                                     BUG23658
     C                   EVAL      ExDtChg = 'Y'                                            BUG23658
     C**********         IF        CER048 = 'Y'                                    BUG23658 BUG23892
     C     KeyDt         CHAIN     SDACTXL1                                                 BUG23658
     C                   IF        %FOUND AND                                               BUG23658
     C                             WExpDat = AXCEEX                                         BUG23658
     C                   EVAL      ExDtChg = 'N'                                            BUG23658
     C                   ENDIF                                                              BUG23658
     C**********         ENDIF                                                     BUG23658 BUG23892
      *                                                                                     BUG23658
     C**********         IF        WExpDat <= BJRDNB                                        BUG23780
     C                   IF        WExpDat < BJRDNB                                         BUG23780
     C                             AND ExDtChg = 'Y'                                        BUG23658
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEEX'
     C**********         EVAL      MsgIdXAr(Idx) = 'USR4785'                                BUG23780
     C                   EVAL      MsgIdXAr(Idx) = 'USR9908'                                BUG23780
     C                   EVAL      OKCEEX = 'N'
     C                   GOTO      EMAIN
     C                   ENDIF
 
     C                   ENDIF
 
      ***Send*error*message*if*expiry*date*is*blank*and*Tax*Status*=*'S'           BUG22912 BUG23544
      ** Send error message if expiry date is blank and Tax Status = 'S'                    BUG23544
 
     C                   EXSR      SRRESI                                                   BUG26250
     C                   IF        DDCEEX = *Blanks AND
     C**********                   DDETXS = 'S'                                               CER048
     C**********                   DDETXS = 'S' AND CER048 = 'N'                     CER048 BUG22912
     C**********                   CER048 = 'N'                                    BUG22912 BUG23544
     C**********                   DDETXS = 'S' AND CER048 = 'N'          BUG22912 BUG23544 BUG23892
     C**********                   DDETXS = 'S'                                    BUG23892 BUG26250
     C                             DDETXS = 'S' AND                                         BUG26250
     C                             WResi = 'N'                                              BUG26250
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEEX'
     C                   EVAL      MsgIdXAr(Idx) = 'USR4786'
     C                   EVAL      OKCEEX = 'N'
     C                   GOTO      EMAIN
     C                   ENDIF
      **********                                                                     232543 BUG23892
      ***Expiry*Date must be input if Cert Reference was entered.                    232543 BUG23892
      **********                                                                     232543 BUG23892
     C**********         IF        DDCEEX = *Blanks And                              232543 BUG23892
     C**********                   DDCERF <> *Blanks                                   232543 CER048
     C**********                   DDCERF <> *BLANKS AND                             CER048 BUG23892
     C**********                   CER048 = 'N'                                      CER048 BUG23892
     C**********         EVAL      Idx = Idx + 1                                     232543 BUG23892
     C**********         EVAL      FldNamXAr(Idx) = 'DDCEEX'                         232543 BUG23892
     C**********         EVAL      MsgIdXAr(Idx) = 'USR4800'                         232543 BUG23892
     C**********         EVAL      OKCEEX = 'N'                                      232543 BUG23892
     C**********         GOTO      EMAIN                                             232543 BUG23892
     C**********         ENDIF                                                       232543 BUG23892
 
      ***Certifacte*of Expiry Date should be blank if Status is not 'S'                       232543
      **********                                                                              232543
     C**********         IF        DDETXS <> 'S' AND DDCEEX <> *Blanks                        232543
     C**********         EVAL      Idx = Idx + 1                                              232543
     C**********         EVAL      FldNamXAr(Idx) = 'DDCEEX'                                  232543
     C**********         EVAL      MsgIdXAr(Idx) = 'USR4793'                                  232543
     C**********         EVAL      OKCEEX = 'N'                                               232543
     C**********         GOTO      EMAIN                                                      232543
     C**********         ENDIF                                                                232543
 
      ** Return to calling program
 
     C                   EVAL      OKCEEX = 'Y'
     C                   EVAL      CTCEEX = WExpDat
 
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************                     BUG26250
      *                                                               *                     BUG26250
      * SRRESI - Check if customer is a resident or non resident      *                     BUG26250
      *                                                               *                     BUG26250
      *****************************************************************                     BUG26250
     C     SRRESI        BEGSR                                                              BUG26250
                                                                                            BUG26250
     C                   EVAL      WResi = 'N'                                              BUG26250
                                                                                            BUG26250
     C                   EVAL      PRTCD = *BLANKS                                          AR740196
     C                   IF        PModeOfOp <> '*VU '                                      AR740196
     C                   CALL      'AOCUSTR1'                                               BUG26250
     C                   PARM      *BLANKS       PRTCD                                      BUG26250
     C                   PARM      '*KEY   '     POPTN                                      BUG26250
     C                   PARM      DDCUST        PKEY1                                      BUG26250
     C                   PARM                    PKYST                                      BUG26250
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG26250
     C                   ENDIF                                                              AR740196
      *                                                                                     BUG26250
      ** If country of location is equal to country of tax code, customer is                BUG26250
      ** a resident                                                                         BUG26250
      *                                                                                     BUG26250
     C                   IF        PRTCD = *BLANKS                                          BUG26250
     C                   IF        BBCOLC = DDCTTX                                          BUG26250
     C                   EVAL      WResi  = 'Y'                                             BUG26250
     C                   ENDIF                                                              BUG26250
     C                   ENDIF                                                              BUG26250
      *                                                                                     BUG26250
     C                   ENDSR                                                              BUG26250
                                                                                            BUG26250
      *****************************************************************                     BUG26250
     C/EJECT                                                                                BUG26250
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    RetCodeIn
                                                                                            AR740196
      ** Mode of Operation                                                                  AR740196
     C                   PARM                    PModeOfOp                                  AR740196
 
      ** New Detail in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Rundate
     C                   PARM                    BJRDNB
 
     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Screen Error Indicator
     C                   PARM                    OKFlags
 
      ** New Details in File Format
     C                   PARM                    NwDLFilFmt
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
      *                                                                                     BUG23658
     C     KeyDt         KLIST                                                              BUG23658
     C                   KFLD                    DDCUST                                     BUG23658
     C                   KFLD                    DDCTTX                                     BUG23658
      *                                                                                       CER048
      ** Check if CER048 is switched on in SCSARDPD                                           CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      '       '     PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = ' SCSARDPD'                                       CER048
     C                   MOVE      '001'         DBASE                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
