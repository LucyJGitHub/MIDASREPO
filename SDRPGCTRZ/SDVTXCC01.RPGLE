     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Details Crosscheck')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVTXCC01 - Tax Details Crosscheck                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10069           Date 25Jan06               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG10069 - Access to customer details no longer required     *
      *             (causes database error).                          *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ***Country*of Tax Codes by County                                                       232543
     F*SDCTTXL2**IF   E           K DISK    INFSR(*PSSR)                                      232543
      ** Customer Details by Country of Tax                                                   232543
     F***SDACTXL0  IF   E           K DISK    INFSR(*PSSR)                             232543 CER059
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                       CER059
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D TaxStatus       S              1
     D PJACType        S              1                                                       232543
     D DDDBTH          S              8
     D DDBTHC          S              2
     D DDBTHT          S             35
     D DDCUST          S              6
     D DDTINO          S             25
     D DDCOLC          S              2                                                       232543
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S             10
     D PKYST           S              7
     D DDOKTINO        S              1
     D DDOKDBTH        S              1
     D DDOKBTHC        S              1
     D DDOKBTHT        S              1
 
      ** Key Fields                                                                           232543
     D KCUST           S                   LIKE(BBCUST)                                       232543
     D KCOLC           S                   LIKE(BBCOLC)                                       232543
                                                                                              232543
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Validation
 
     C                   EXSR      SRVTXCC
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKTINO = 'N' or DDOKDBTH = 'N' or
     C                             DDOKBTHC = 'N' or DDOKBTHT = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTXCC - Validate Tax Identication Number                    *
      *                                                               *
      *****************************************************************
 
     C     SRVTXCC       BEGSR
 
      ** Birth information or Tax ID cannot be both blank if
      ** Tax Status is 'D'isclosed
      ** and Joint A/c Type is 'I' or 'Y' (not 'N')                                           232543
 
     C                   IF        TaxStatus = 'D'
     C                             And PJACType <> 'N'                                        232543
 
     C                   IF        DDTINO = *Blanks  and
     C                             DDDBTH = *Blanks  and
     C                             DDBTHC = *Blanks  and
     C                             DDBTHT = *Blanks
     C                   EVAL      DDOKTINO = 'N'
     C                   EVAL      DDOKDBTH = 'N'
     C                   EVAL      DDOKBTHC = 'N'
     C                   EVAL      DDOKBTHT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTINO'      FldNamXAr(Idx)
     C                   MOVEL     'USR4781'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If Tax ID is blank, all details on birth information should
      ** not be blank
 
     C                   IF        DDTINO = *Blanks
 
     C                   IF        DDDBTH = *Blanks
     C                   EVAL      DDOKDBTH = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDBTH'      FldNamXAr(Idx)
     C                   MOVEL     'USR4782'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C                   IF        DDBTHC = *Blanks
     C                   EVAL      DDOKBTHC = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDBTHC'      FldNamXAr(Idx)
     C                   MOVEL     'USR4782'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C                   IF        DDBTHT = *Blanks
     C                   EVAL      DDOKBTHT = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDBTHT'      FldNamXAr(Idx)
     C                   MOVEL     'USR4782'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ***Access*Customer*Details***************************************                     BUG10069
      *****************************************************************                     BUG10069
     C**********         MOVEL     DDCUST        PKEY1                                      BUG10069
      *****************************************************************                     BUG10069
     C**********         CALL      'AOCUSTR0'                                               BUG10069
     C**********         PARM      *Blanks       PRTCD                                      BUG10069
     C**********         PARM      '*KEY   '     POPTN                                      BUG10069
     C**********         PARM                    PKEY1                                      BUG10069
     C**********         PARM                    PKYST                                      BUG10069
     C*****SDCUST        PARM      SDCUST        DSSDY                                      BUG10069
      *****************************************************************                     BUG10069
      ***Database*Error************************************************                     BUG10069
      *****************************************************************                     BUG10069
     C**********         IF        PRTCD <> *Blanks                                         BUG10069
     C**********         EVAL      DBFILE = 'SDCUSTPD'                                      BUG10069
     C**********         EVAL      DBASE = 010                                              BUG10069
     C**********         EVAL      DBKEY = PKEY1                                            BUG10069
     C**********         EXSR      *PSSR                                                    BUG10069
     C**********         ENDIF                                                              BUG10069
 
      ** Initialize the Tax Status
 
     C**********         EVAL      EWTXS1 = *Blanks                                           232543
     C                   EVAL      TaxStatus = *Blanks
     C                   EVAL      AXETXS = *Blanks                                           232543
 
      ** Access Tax Status from Customer's Country of Residence
 
     C*****BBCOLC        SETLL     SDCTTXL2                                                   232543
     C*****BBCOLC        READE     SDCTTXL2                                                   232543
     C*****DDCUST        SETLL     SDACTXL0                                            232543 CER059
     C*****DDCUST        READE     SDACTXL0                                            232543 CER059
     C     DDCUST        SETLL     SDACTXL1                                                   CER059
     C     DDCUST        READE     SDACTXL1                                                   CER059
 
     C**********         DOW       NOT %EOF(SDCTTXL2)                                         232543
     C**********                   AND EWTXS1 <> 'D'                                          232543
     C*****BBCOLC        READE     SDCTTXL2                                                   232543
     C**********         DOW       Not %EOF(SDACTXL0)                                  232543 CER059
     C                   DOW       Not %EOF(SDACTXL1)                                         CER059
     C                             And AXETXS <> 'D'                                          232543
     C*****DDCUST        READE     SDACTXL0                                            232543 CER059
     C     DDCUST        READE     SDACTXL1                                                   CER059
     C                   ENDDO
 
     C**********         EVAL      TaxStatus = EWTXS1                                         232543
     C                   IF        AXETXS = 'D'                                               232543
     C                   EVAL      TaxStatus = AXETXS                                         232543
     C                   ENDIF                                                                232543
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number
     C                   PARM                    DDCUST
 
      ** Tax Identification Number
     C                   PARM                    DDTINO
 
      ** Birth information (date, country and town)
     C                   PARM                    DDDBTH
     C                   PARM                    DDBTHC
     C                   PARM                    DDBTHT
 
     C                   PARM                    DDCOLC                                       232543
                                                                                              232543
     C                   PARM                    PJACType                                     232543
                                                                                              232543
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
      ** Date of Birth - OK
      ** Country of Birth - OK
      ** Town of Birth - OK
      ** Tax Status                                                                           232543
     C                   PARM                    DDOKTINO
     C                   PARM                    DDOKDBTH
     C                   PARM                    DDOKBTHC
     C                   PARM                    DDOKBTHT
     C                   PARM                    TaxStatus                                    232543
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
