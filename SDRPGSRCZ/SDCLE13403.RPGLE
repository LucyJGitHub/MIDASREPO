     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('TAKE-ON - Initialise New Fields on SDLOANPD')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE13403 - Initialise New Fields on SDLOANPD               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FSDLOANL1  UP   E           K DISK
 
      *****************************************************************
     D/EJECT
      *****************************************************************
 
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D DSLoop          S              9  0 INZ
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** Main Processing Control
 
      ** Process Record
 
     C                   EXSR      SRSDLOANL1
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSDLOANL1 - Process Loan Standing Data                      *
      *****************************************************************
     C     SRSDLOANL1    BEGSR
 
      ** Initialise Miscellaneous Values
 
     C                   EVAL      AYCAPI = *BLANKS
     C                   EVAL      AYSIIN = *BLANKS
     C                   EVAL      AYFAMU = *BLANKS
 
     C                   EVAL      AYOVRD = *BLANKS
     C**********         EVAL      AYPCKO = 0                                                 CLE164
 
      ** Initialise Principal Values
 
     C                   EVAL      AYPPLT = *BLANKS
     C                   EVAL      AYPPLS = *BLANKS
     C                   EVAL      AYPPLC = *BLANKS
 
     C                   EVAL      AYPBSR = 0
     C                   EVAL      AYPRSP = 0
     C                   EVAL      AYPRSI = *BLANKS
     C                   EVAL      AYPICB = 0
 
     C                   EVAL      AYPOPR = *BLANKS
 
      ** Initialise Interest Values
 
     C                   EVAL      AYIPLT = *BLANKS
     C                   EVAL      AYIPLS = *BLANKS
     C                   EVAL      AYIPLC = *BLANKS
 
     C                   EVAL      AYIBSR = 0
     C                   EVAL      AYIRSP = 0
     C                   EVAL      AYIRSI = *BLANKS
     C                   EVAL      AYIICB = 0
 
      ** Update Loan Details
 
     C                   UPDATE(E) @AYRECL
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
