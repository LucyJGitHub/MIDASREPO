     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Retrieve Effective Interest Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MM000020 - MM Retrieve Effective Interest Rate               *
      *                                                               *
      *  Function:  This program accesses details from MMEIRDPD       *
      *             with parameter of Transaction Reference and       *
      *             return Effective Interest Rate in Alpha.          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         File Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess     -  Get EIR                                     *
      *  SRINIT        -  Program Initialisation Routine              *
      *  *PSSR         -  Error processing                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMEIRDL8  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
     D PTemp           S             15A
     D PEIROut         S             14A
     D EIRNum          S             13P 9
 
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
      ** MAIN PROCEDURE                                                   *
      *********************************************************************
 
      ** Execute initialisation
 
     C                   EXSR      SRINIT
 
      ** Initialise Return Parameter
     C                   EVAL      P@EIR = *BLANKS
 
     C     P@TRAN        SETGT     MMEIRDL8
     C     P@TRAN        READPE    MMEIRDL8                               90
     C                   IF        *IN90 = *OFF
     C                   EXSR      SRProcess
     C                   ENDIF
 
      ** Return to caller
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Get EIR                                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   EVAL      EIRNum = EIEIR * 100
 
     C                   CALLB     'ZRATE3'
     C                   PARM                    EIRNum
     C                   PARM                    PEIROut
 
     C                   MOVE      PEIROut       PTemp
     C                   IF        EIEIR < 0
     C     PTemp         CAT       '-':0         P@EIR
     C                   ELSE
     C                   MOVE      PTemp         P@EIR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    P@TRAN
     C                   PARM                    P@EIR            16
 
     C     *LIKE         DEFINE    EITRAN        P@TRAN
 
 
     C                   ENDSR
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        RunBefore = *BLANK
     C                   DUMP
     C                   EVAL      RunBefore = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      *****************************************************************
