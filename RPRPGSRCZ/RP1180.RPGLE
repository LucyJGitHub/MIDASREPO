     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Additional processing for deal amendments')   *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1180 - Midas-Plato Interface                               *
      *           Additional Processing for deal amendments           *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Real-time Interface               *
      *                                                               *
      * For each record on PF/DEAMSDI get record in L/F DEALS and     *
      *   perform update to L/F DEALS. This in turn will trigger pre- *
      *   process for the deal itself, which will include processing  *
      *   of the deal amendment.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 AR858264           Date 02Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 16May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 217684             Date 12May03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPL005  *CREATE    Date 16Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR858264 - Compilation Issues on RP1180 and RP1190           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  217684 - Authorisation User Malfunction (Recompile).         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CPL005 - Midas-Plato Real-time Interface.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80 - End of records for key on PF/TRANSD                   *
      *    U7 - Error encountered in processing                       *
      *    LR - Last Record - End program                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALS     UF   E           K DISK
 
      /EJECT
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY contains various standard declares
     C**********/COPY RPCPYSRC,Std_Dcl                                                      AR858264
     C/COPY RPCPYSRC,STD_DCL                                                                AR858264
 
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C**********/COPY RPCPYSRC,Mdn_Hd_DS                                                    AR858264
     C/COPY RPCPYSRC,MDN_HD_DS                                                              AR858264
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Key to PF/DEAMSDI.
     D@KDEAMSds        DS
     D @KDLNOA                 1      6A
     D @KDLNO                  1      6S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** Extract the Deal Number from the data input.
 
     C                   Eval      @KDLNOA = %subst(TransData:24:6)
 
      ** Access original record on PF/DEALSDC.
 
     C     @KDLNO        Chain     DEALS                              90
 
      ** If error then perform any special processing and exit
 
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EVAL      TNLU = TNLU + 1
 
     C                   UPDATE    DEALSDCF
 
      ** Return control at the end of the processing for the message.
 
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         Begsr
 
      ** If error in RP1110, set Return Code accordingly.
 
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1180')
     C                   EndIf
 
     C     @RUN          IfEq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   EndIf
 
     C                   SetOn                                        U7U8LR
     C                   Return
 
     C                   Endsr
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Transaction Data
     C                   PARM                    TransData
      ** Return Code
     C                   PARM                    ReturnCode
 
     C                   ENDSR
 
      *****************************************************************
