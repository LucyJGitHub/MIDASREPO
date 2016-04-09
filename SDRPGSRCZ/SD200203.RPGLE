     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Take On NAHO & ACUS Religious Affiliation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD200203 - Midas SD Take On NAHO and ACUS Religious          *
      *             Affiliation                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054   *CREATE   Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInzRlafAcus - Initialise Religious Affiliation in SDACUSPD *
      *  SRInzRlafNaho - Initialise Religious Affiliation in SDNAHOPD *
      *  *PSSR         - Error Processing                             *
      *                                                               *
      *****************************************************************
      *
      ** Midas SD Additional customer details
     FSDACUSPD  UF   E             DISK    INFSR(*PSSR)
      *
      ** Midas SD Non-account Holders
     FSDNAHOPD  UF   E             DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D Wrun            S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Process all records in file SDACUSPD
      *
     C                   EXSR      SRInzRlafAcus
      *
      ** Process all records in file SDNAHOPD
      *
     C                   EXSR      SRInzRlafNaho
      *
      ** Return to calling program
      *
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInzRlafAcus - Initialise Religious Affiliation in SDACUSPD *
      *                                                               *
      *****************************************************************
      *
     C     SRInzRlafAcus BEGSR
      *
      ** Read all records from SDACUSPD file
      *
     C     1             SETLL     SDACUSPD
     C                   READ      SDACUSPD
      *
     C                   DOW       NOT(%EOF)
      *
      ** If Religious Affiliation code is *BLANKS, change it to 'NONE'
      *
     C                   IF        E5RLAF = *BLANKS
     C                   EVAL      E5RLAF = 'NONE'
      *
      ** Update the record in SDACUSPD
      *
     C                   UPDATE    SDACUSD0
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDACUSPD
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInzRlafNaho - Initialise Religious Affiliation in SDNAHOPD *
      *                                                               *
      *****************************************************************
      *
     C     SRInzRlafNaho BEGSR
      *
      ** Read all records in SDNAHOPD file
      *
     C     1             SETLL     SDNAHOPD
     C                   READ      SDNAHOPD
      *
     C                   DOW       NOT(%EOF)
      *
      ** If Religious Affiliation code is *BLANKS, change it to 'NONE'
      *
     C                   IF        NHRLAF = *BLANKS
     C                   EVAL      NHRLAF = 'NONE'
      *
      ** Update record in SDNAHOPD
      *
     C                   UPDATE    SDNAHOD0
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDNAHOPD
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Error control subroutine                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
      *
     C                   DUMP
      *
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2009
