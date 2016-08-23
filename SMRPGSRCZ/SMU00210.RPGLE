     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility Program to re-populate RECUSXQD')     *
      *****************************************************************
      *                                                               *
      *  Midas - Utility Program                                      *
      *                                                               *
      *  SMU00210 - Utility Program to re-populate RECUSXQD           *
      *                                                               *
      *  Function:  This program will populate the IPDN of RECUSXQD   *
      *             based on CUSEXCE                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23903 *CREATE   Date 05May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23903 - Insert of CUSX records through SOAP interface     *
      *             fails                                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Customer Exchanges Details File
      *
     FCUSEXCE   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas Customer Exchanges Extension File
      *
     FRECUSXQD  O    E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *
     C                   READ      CUSEXCE
      *
     C                   DOW       (NOT %EOF(CUSEXCE))
      *
     C                   EVAL      CUIPDN = IPDN
     C                   EVAL      CUFRID = *BLANKS
      *
     C                   WRITE     RECUSXD0
      *
     C                   READ      CUSEXCE
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
