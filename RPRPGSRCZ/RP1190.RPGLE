     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Additional Processing for Deal Amendments')   *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1190 - Midas-Plato Interface                               *
      *           Additional Processing for Loan amendments           *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Real-time Interface               *
      *                                                               *
      * For each record on PF/LOAMSDK get record in L/F CLOAN and     *
      *   perform update to L/F CLOAN. This in turn will trigger pre- *
      *   process for the deal itself, which will include processing  *
      *   of the deal amendment.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR858264           Date 02Dec11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPL005  *CREATE    Date 16Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR858264 - Compilation Issues on RP1180 and RP1190           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CPL005 - Midas-Plato Real-time Interface.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80 - End of records for key on PF/CLOAN                    *
      *    U7 - Error encountered in processing                       *
      *    LR - Last Record - End program                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCLOAN     UF   E           K DISK    IGNORE(CLOANHHF:CLOANZ1F)

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

      **   Key to PF/LOAMSDK.
     D@KCLOANds        DS
     D @KLNRFA                 1      6    INZ(*Blanks)
     D @KLNRF                  1      6S 0 INZ(*Zeros)

     D @KRCDT          S                   LIKE(RCDT) INZ(*Zeros)

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

     C                   Eval      @KLNRFA = %subst(TransData:24:6)
     C                   Eval      @KRCDT  = 'A'

      ** Access original record on PF/CLOANCL.

     C     @KCLOAN       Chain     CLOANCLF                           80

      ** If error then perform any special processing and exit

     C                   If        *IN80 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf

     C                   EVAL      TNLU = TNLU + 1

     C                   UPDATE    CLOANCLF

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
     C                   Eval      ReturnCode = ('ErrRP1190')
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

      ** Key list for LF/CLOAN

     C     @KCLOAN       KLIST
     C**********         KFLD                    @KLNRF                                       CLE148
     C                   KFLD                    @KLNRFA                                      CLE148
     C                   KFLD                    @KRCDT

     C                   ENDSR

      *****************************************************************
