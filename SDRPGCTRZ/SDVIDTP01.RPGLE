     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Identification Type')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVTINO01 - Validate Identification Type                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR671813           Date 23Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25053           Date 21Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR671813 - Bypass validation done by BUG25053 if CER034 is   *
      *             turned on. Applied for MD033988                   *
      *  BUG25053 - Blank Tax ID No. must not be accepted by the      *
      *             system if Identification type is defined          *
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
 
      ** Identification Types Detail Files
     FSDIDTPL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** External DS for SAR Details                                                        AR671813
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR671813
      ** External data structure for access programs (short)                                AR671813
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   AR671813
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D WorkNumeric     S             26
     D DDTINO          S             25
     D DDIDTP          S              2
     D DDOKIDTP        S              1
 
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
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
      ** Validation
 
     C                   EXSR      SRVIDTP
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKIDTP = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVIDTP - Validate Identication Type                          *
      *                                                               *
      *****************************************************************
 
     C     SRVIDTP       BEGSR
 
      ** If Identification Type is blank, TIN should be blanks                              BUG25053
                                                                                            BUG25053
     C                   If        DDTINO = *BLANKS And                                     BUG25053
     C**********                   DDIDTP <> *BLANKS                               BUG25053 AR671813
     C                             DDIDTP <> *BLANKS And                                    AR671813
     C                             CER034 = 'N'                                             AR671813
     C                   EVAL      DDOKIDTP = 'N'                                           BUG25053
     C                   ADD       1             Idx                                        BUG25053
     C                   MOVEL     'DDIDTP'      FldNamXAr(Idx)                             BUG25053
     C                   MOVEL     'Y2U0033'     MsgIDXAr(Idx)                              BUG25053
     C                   GOTO      ENDVAL                                                   BUG25053
     C                   ENDIF                                                              BUG25053
                                                                                            BUG25053
      ** If TIN is entered, Identification Type is mandatory
 
     C                   IF        DDTINO <> *Blanks AND
     C                             DDIDTP =  *Blanks
     C                   EVAL      DDOKIDTP = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDTP'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4762'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If Identification Type is entered, it should be defined
 
     C                   IF        DDIDTP <> *Blanks
     C     DDIDTP        CHAIN     SDIDTPL1
 
     C                   IF        NOT %FOUND(SDIDTPL1)
     C                   EVAL      DDOKIDTP = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDIDTP'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4756'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
     C     ENDVAL        ENDSR
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
      ** Tax Identication Number
     C                   PARM                    DDTINO
 
      ** Identication Type
     C                   PARM                    DDIDTP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Identification Type - OK
     C                   PARM                    DDOKIDTP
 
      *                                                                                     AR671813
      ** Check if CER034 is enabled                                                         AR671813
      *                                                                                     AR671813
     C                   CALL      'AOSARDR0'                                               AR671813
     C                   PARM      *Blanks       PRtcd             7                        AR671813
     C                   PARM      '*VERIFY'     POptn             7                        AR671813
     C                   PARM      'CER034'      PSard             6                        AR671813
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR671813
                                                                                            AR671813
     C                   MOVEL     'N'           CER034            1                        AR671813
                                                                                            AR671813
     C                   IF        PRtcd = *BLANKS                                          AR671813
     C                   EVAL      CER034 = 'Y'                                             AR671813
     C                   ELSE                                                               AR671813
                                                                                            AR671813
      ** Handle Datebase Error.                                                             AR671813
                                                                                            AR671813
     C                   IF        PRtcd <> '*NRF   '                                       AR671813
     C     *LOCK         IN        LDA                                                      AR671813
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR671813
     C                   EVAL      DBKEY = 'CER034'                                         AR671813
     C                   EVAL      DBASE = 001                                              AR671813
     C                   OUT       LDA                                                      AR671813
     C                   EXSR      *PSSR                                                    AR671813
     C                   ENDIF                                                              AR671813
     C                   ENDIF                                                              AR671813
 
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
