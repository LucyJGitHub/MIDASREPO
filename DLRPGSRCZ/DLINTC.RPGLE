     H DEBUG
     H COPYRIGHT('© Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Interest Calculation')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing module                                       *
      *                                                               *
      *  DLINTC - DL Interest Calculation                             *
      *                                                               *
      *  Function:  This module calculates interest for Money Market  *
      *             loans & deposits which are tied to a base rate    *
      *             by processing the Deal Interest Rate History file.*
      *                                                               *
      *  Called by: DL0280 Deals File Update Phase 2                  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD027681           Date 02Jul14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL034  *CREATE    Date 08Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027681 - Incorrect int. accrued calculation                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CDL034 - Back-valued Base Rate changes for MM deals          *
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
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FDlDIRHPd  UF A E           K Disk
      ** Deal Interest Rate History

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

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

     D @RUN            S              1
     D P@Dlno          S                   Like(A2DlNo)
     D P@Slid          S                   Like(A2Hisd)
     D P@NiDt          S                   Like(A2Hisd)
     D P@IdMd          S              1
     D P@CalcInt       S                   Like(A2AInP)
     D P@AInP          S                   Like(A2AInP)

     D P@Begin         S                   Like(A2Hisd)
     D P@End           S                   Like(A2Hisd)
     D P@Basis         S                   Like(A2Icbs)
     D P@Amount        S             15  0
     D P@Rate          S                   Like(A2IntR)
     D P@Interest      S             30  9
     D P@Pcpl          S             13  0                                                  MD027681

     D Wk#13d0         S             13  0
     D WkLastDate      S              5  0 Inz(0)
     D WkThisDate      S              5  0 Inz(0)
     D WkPcpl          S                   Like(A2Pcpl)
     D WkIntR          S                   Like(A2IntR)
     D WkAInP          S                   Like(A2AInP)
     D WkCalcInt       S                   Like(A2AInP)
     D WkNew           S              1                                                     MD027681

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

      ** Start reading history from last interest date

     C     DealHistKey   SetLL     DlDIRHPd

      ** Read all history records for this deal

     C                   DoU       %EoF
     C     P@DlNo        ReadE     DlDIRHPd
     C                   If        Not %EoF

      * (Include accrued interest from take-on. First int. date only)
     C                   Add       A2AID1        WkCalcInt

     C                   Eval      WkLastDate = WkThisDate
     C                   Eval      WkThisDate = A2HisD
     C                   IF        A2Hisd <= P@NiDt                                         MD027681
      *                                                                                     MD027681
      ** Use correct principal for computation of interest                                  MD027681
      ** and update DLDIRHPD with correct principal                                         MD027681
      *                                                                                     MD027681
     C                   IF        A2Hisd = P@NiDt                                          MD027681
     C                             And A2Pcpl <> P@Pcpl                                     MD027681
     C                             And P@IdMd = 'I'                                         MD027681
     C                   EVAL      WkPcpl = P@Pcpl                                          MD027681
     C                   EVAL      A2Pcpl = P@Pcpl                                          MD027681
     C                   UPDATE    DlDIRHd0                                                 MD027681
     C                   ENDIF                                                              MD027681
      *                                                                                     MD027681
     C                   ExSr      Sr_GlintC
     C                   Eval      WkPcpl = A2Pcpl
     C                   Eval      WkIntR = A2IntR
      *                                                                                     MD027681
      ** WkLastDate and WkPcpl are not set first time through so                            MD027681
      ** calculated interest is zero. A2AinP which corresponds to the                       MD027681
      ** previous period should therefore not be included either.                           MD027681
      *                                                                                     MD027681
     C                   IF        WkLastDate <> 0                                          MD027681
     C                   EVAL      WkAInP = WkAinP + A2AinP
     C                   ENDIF                                                              MD027681
     C                   If        P@NiDt > A2Hisd
     C                             or (P@NiDt = A2Hisd and P@IdMd = 'M')
     C                   ExSr      Update_IRH
     C                   EndIf
     C                   EndIf
     C                   ENDIF                                                              MD027681
     C                   EndDo

      ** If no history record exists for next interest date perform extra
      ** calculation to cover the final period.

     C                   If        P@NiDt > A2Hisd and
     C                             P@NiDt <> 99999
     C                   Eval      WkLastDate = WkThisDate
     C                   Eval      WkThisDate = P@NiDt
     C                   ExSr      Sr_GlintC
     C                   ExSr      Write_IRH
     C                   EndIf

      ** Set up return parameters

     C                   Eval      P@CalcInt = WkCalcInt
     C                   Eval      P@AInP = WkAInP
     C                   Eval      *InLR = *On
     C                   Return

      *******************************************************************
      /EJECT
      *******************************************************************
      *
      *  Sr_GlintC - To calculate interest accrued between two dates
      *
      *  Called by: Main processing
      *
      *******************************************************************

     C     Sr_GlIntC     BegSr

     C                   Eval      P@Begin = WkLastDate
     C                   Eval      P@End = WkThisDate
     C                   Eval      P@Basis = A2ICBs
     C********           Eval      P@Amount = WkPcpl                                        MD027681
     C                   EVAL      P@Amount = P@Pcpl                                        MD027681
     C                   Eval      P@Rate = WkIntR
     C                   CallB     'GLINTC'      PL_GlIntC
     C                   Z-Add(H)  P@Interest    Wk#13d0
     C                   Add       Wk#13d0       WkCalcInt

     C                   EndSr
      /EJECT
      *******************************************************************
      *
      *  Update_IRH SR - To flag interest history record as processed
      *
      *  Called by: Main processing
      *
      *******************************************************************

     C     Update_IRH    BegSr

     C                   Eval      A2RecI = 'P'
     C                   If        P@IdMd = 'M' and P@NiDt = A2Hisd
     C                   Eval      A2Pcpl = 0
     C                   EndIf
     C                   Update    DlDIRHd0

     C                   EndSr
      /EJECT
      *******************************************************************
      *
      *  Write_IRH SR - To write interest history record for next
      *                 interest date or maturity
      *
      *  Called by: Main processing
      *
      *******************************************************************

     C     Write_IRH     BegSr

     C                   Eval      A2RecI = 'D'
     C                   Eval      A2HisD = P@NiDt
     C                   EVAL      A2Pcpl = P@Pcpl                                          MD027681
     C                   If        P@IdMd = 'M'
     C                   Eval      A2RecI = 'P'
     C                   Eval      A2Pcpl = 0
     C                   EndIf
     C                   Eval      A2AInP = 0
     C                   Eval      A2AID1 = 0
     C                   Write     DlDIRHd0

     C                   EndSr
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

     C     *InzSr        BegSr

     C     *Entry        Plist
     C                   Parm                    P@DlNo
     C                   Parm                    P@Slid
     C                   Parm                    P@NiDt
     C                   Parm                    P@IdMd
     C                   Parm                    P@CalcInt
     C                   Parm                    P@AInP
     C                   Parm                    P@Pcpl                                     MD027681

      ** Parameter list for interest calculation

     C     PL_GlIntC     Plist
     C                   Parm                    P@Begin
     C                   Parm                    P@End
     C                   Parm                    P@Basis
     C                   Parm                    P@Amount
     C                   Parm                    P@Rate
     C                   Parm                    P@Interest

      ** Define key list

     C     DealHistKey   Klist
     C                   KFld                    P@DlNo
     C                   KFld                    P@Slid

     C                   EndSr

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

     C     *PSSR         BegSr

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   EndSr

      ********************************************************************
