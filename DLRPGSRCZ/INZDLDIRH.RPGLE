     H DEBUG
     H COPYRIGHT('© Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Initialise Deal Interest Rate History')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing module                                       *
      *                                                               *
      *  INZDLDIRH - Initialise Deal Interest Rate History            *
      *                                                               *
      *  Function:  This module initialises DLDIRHPD on installation  *
      *             of CDL034.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL034  *CREATE    Date 08Mar05               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL034 - Back-valued Base Rate changes for MM deals          *
      *                                                               *
      *****************************************************************
      /EJECT
     FDealsDC   IF   E             Disk    Prefix(A2)
      * MM Deals
 
     FDlDIRHpd  UF A E             Disk
      ** Deal Interest Rate History
      /EJECT
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
 
     D Dsfdy         E DS                  extname(DSFDY)
     D Dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D P@Begin         S                   Like(A2Hisd)
     D P@End           S                   Like(A2Hisd)
     D P@Basis         S                   Like(A2Icbs)
     D P@Amount        S             15  0
     D P@Rate          S                   Like(A2IntR)
     D P@Interest      S             30  9
      /EJECT
 
      ** Main Processing
 
     C                   Read      DealsDC                                LR
     C                   DoW       *InLR = *Off
 
      ** Write Interest Rate History record for live deals
 
     C                   If        A2RECI = 'D' and A2BRTT <> 0
     C                   ExSr      Write_IRH
     C                   EndIf
 
     C                   Read      DealsDC                                LR
     C                   EndDo
 
     C                   Return
      /Eject
      *******************************************************************
      *
      *  Write_IRH SR - To write interest history record
      *
      *  Called by: Main processing
      *
      *******************************************************************
 
     C     Write_IRH     BegSr
 
      ** Populate fields not implicitly filled
 
     C                   Eval      A2HisD = BjRdNb
     C                   Eval      A2CyCd = A2CCY
     C                   Eval      A2Brt = A2BRTT
     C                   Eval      A2Cbsr = A2BRTE
     C                   Eval      A2AInp = 0
     C                   ExSr      Sr_GlintC
     C                   Z-Add(H)  P@Interest    A2AId1
     C                   Write     DlDIRHd0
 
     C                   EndSr
      /Eject
      *******************************************************************
      *
      *  Sr_GlintC - To calculate interest accrued between two dates
      *
      *  Called by: Main processing
      *
      *******************************************************************
 
     C     Sr_GlIntC     BegSr
 
     C                   Eval      P@Begin = A2IACD
     C                   Eval      P@End = BjRdNb
     C                   Eval      P@Basis = A2ICBs
     C                   Eval      P@Amount = A2Pcpl
     C                   Eval      P@Rate = A2IntR
     C                   CallB     'GLINTC'      PL_GlIntC
 
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
 
      ** Parameter list for interest calculation
 
     C     PL_GlIntC     Plist
     C                   Parm                    P@Begin
     C                   Parm                    P@End
     C                   Parm                    P@Basis
     C                   Parm                    P@Amount
     C                   Parm                    P@Rate
     C                   Parm                    P@Interest
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
