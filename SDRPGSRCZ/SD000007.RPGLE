     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CGL047')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000007 - Initialisation Program for CGL047                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 141037             Date 24Aug06               *
      *                 CGL047  *CREATE    Date 03Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  141037 - Remove references to LDA                            *
      *  CGL047 - Generic Posting Interface                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas Account Keys file
     FACKEY     UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D*LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                           141037
 
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** SAR Descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters used by access object
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Check if account key 'INTCREDIT ' exists
     C                   Eval      Akey = 'INTCREDIT '
     C     Akey          Chain(n)  ACKEYALF
     C                   If        Not %Found
     C                   Eval      Reci = 'D'
     C                   Eval      Akey = 'INTCREDIT '
     C                   Eval      NCD1 = *Blanks
     C                   Eval      NCD2 = *Blanks
     C                   Eval      NCD3 = *Blanks
     C                   Eval      NCD4 = '99'
     C                   Eval      NCD5 = *Blanks
     C                   Eval      NCD6 = *Blanks
     C                   Eval      PRF1 = 0
     C                   Eval      PRF2 = 0
     C                   Eval      PRF3 = 0
     C                   Eval      PRF4 = 2
     C                   Eval      PRF5 = 0
     C                   Eval      PRF6 = 0
     C                   Eval      LCD  = BJRDNB
     C                   Eval      CHTP = 'I'
     C                   Write     ACKEYALF
     C                   Add       1             ##Nore            5 0
     C                   Endif
 
      ** Check if account key 'INTDEBIT  ' exists
     C                   Eval      Akey = 'INTDEBIT  '
     C     Akey          Chain(n)  ACKEYALF
     C                   If        Not %Found
     C                   Eval      Reci = 'D'
     C                   Eval      Akey = 'INTDEBIT  '
     C                   Eval      NCD1 = '99'
     C                   Eval      NCD2 = *Blanks
     C                   Eval      NCD3 = *Blanks
     C                   Eval      NCD4 = *Blanks
     C                   Eval      NCD5 = *Blanks
     C                   Eval      NCD6 = *Blanks
     C                   Eval      PRF1 = 2
     C                   Eval      PRF2 = 0
     C                   Eval      PRF3 = 0
     C                   Eval      PRF4 = 0
     C                   Eval      PRF5 = 0
     C                   Eval      PRF6 = 0
     C                   Eval      LCD  = BJRDNB
     C                   Eval      CHTP = 'I'
     C                   Write     ACKEYALF
     C                   Add       1             ##Nore            5 0
     C                   Endif
 
      ** Update trailer record if records added
     C                   If        ##Nore > 0
     C                   Eval      Akey = *Blanks
     C     Akey          Chain     ACKEYAKF
     C                   If        %Found
     C                   Add       ##Nore        NINS
     C                   Add       ##Nore        NREC1
     C                   Update    ACKEYAKF
     C                   Endif
     C                   Endif
 
      ** Terminate processing
     C                   Move      *ON           *INLR
     C                   Return
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C***  *LOCK         IN        LDA                                                        141037
     C***                EVAL      DBPGM  =  'SD000007'                                       141037
     C***                OUT       LDA                                                        141037
 
      ** Access AOBANKR0
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM      *BLANKS       DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
