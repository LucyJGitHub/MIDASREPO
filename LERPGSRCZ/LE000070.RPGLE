     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Retrieve Effective Interest Rate')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000070 - LE Retrieve Effective Interest Rate               *
      *                                                               *
      *  Function:  This program accesses details from LEEIRDPD       *
      *             with parameter of Transaction Reference and       *
      *             return Effective Interest Rate in Alpha.          *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 262654             Date 13May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS011  *CREATE    Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  262654 - Enlarge EIR output field to match size of EIR       *
      *           field on LE and MM files.                           *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
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
     FLEEIRDL8  IF   E           K DISK
 
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
     D*EIRNum***       S             13P 9                                                    262654
     D EIRNum          S             16P 8                                                    262654
 
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
 
     C     P@TRAN        SETGT     LEEIRDL8
     C     P@TRAN        READPE    LEEIRDL8                               90
     C                   IF        *IN90 = *OFF
     C                   EXSR      SRProcess
     C                   ENDIF
     C
      ** Return to caller
 
     C                   RETURN
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Get EIR                                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   EVAL      EIRNum = EIEIR * 100
 
     C**********         CALLB     'ZRATE3'                                                   262654
     C**********         PARM                    EIRNum                                       262654
     C**********         PARM                    PEIROut                                      262654
                                                                                              262654
     C                   MOVE      EIRNum        ZFIELD           16                          262654
     C                   Z-ADD     8             ZADEC             2 0                        262654
                                                                                              262654
     C                   CALLB     'ZAEDITM'                                                  262654
     C                   PARM                    ZFIELD                                       262654
     C                   PARM                    ZADEC                                        262654
                                                                                              262654
     C                   MOVE      ZFIELD        P@EIR                                        262654
 
     C**********         MOVE      PEIROut       PTemp                                        262654
     C                   IF        EIEIR < 0
     C*****PTemp         CAT       '-':0         P@EIR                                        262654
     C**********         ELSE                                                                 262654
     C**********         MOVE      PTemp         P@EIR                                        262654
     C                   MOVEL     '-'           P@EIR                                        262654
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
      *
     C     SRINIT        BEGSR
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@TRAN
     C                   PARM                    P@EIR            16
      *
     C     *LIKE         DEFINE    EITRAN        P@TRAN
      *
     C                   ENDSR
      *
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
