     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('TAKE-ON - Initialise New Fields on SDFEEPD')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE13404 - Initialise New Fields on SDFEEPD                *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 AR318270           Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR318270 - Make FEFSFA 'N' rather than blank                 *
      *             (Child : AR321380)                                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FSDFEEL1   UP   E           K DISK
 
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
 
     C                   EXSR      SRSDFEEL1
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSDFEEL1 - Process Fee Standing Data                        *
      *****************************************************************
     C     SRSDFEEL1     BEGSR
 
      ** Initialise Miscellaneous Values
 
     C                   EVAL      AUCLTY = *BLANKS
     C                   EVAL      AUCLST = *BLANKS
     C                   EVAL      AUCLCL = *BLANKS
     C                   EVAL      AUCBSR = 0
     C                   EVAL      AUCRSP = 0
     C                   EVAL      AUCRIN = *BLANKS
     C                   EVAL      AUBSRI = *BLANKS
     C                   EVAL      AUICBS = 0
     C                   EVAL      AUOVRA = *BLANKS
     C                   EVAL      AUFAMU = *BLANKS
 
     C                   EVAL      AUGDPR = 0
     C**********         EVAL      AUPCKO = 0                                                 CLE164
 
      ** Initialise Suspense Values
 
     C**********         EVAL      AUFSFA = *BLANKS                                         AR318270
     C                   EVAL      AUFSFA = 'N'                                             AR318270
     C                   EVAL      AUSFAM = 0
     C                   EVAL      AUSFPM = 0
     C                   EVAL      AUFPYA = *BLANKS
     C                   EVAL      AUPSIN = *BLANKS
     C                   EVAL      AUPSLM = 0
     C                   EVAL      AUFEMC = *BLANKS
 
      ** Update Loan Details
 
     C                   UPDATE(E) @AURECR
 
     C                   ENDSR
