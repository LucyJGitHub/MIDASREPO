     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Analysis Code Data Extract')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI100001 - Midas TI Analysis Code Data Driver File           *
      *             Extract                                           *
      *                                                               *
      *  Function: This program creates Standing Data Driver File     *
      *             Update for TI Analysis Code                       *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006  *CREATE    Date 31Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRExtrANAL - Extract TI Analysis Code Driver File             *
      * *INZSR  - Initialisation sub-routine                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Trade Innovation Customer Details
     FSDTICSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas TI Analysis Code Data Driver File
     FTIANCDPD  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** Maximum number of analysis code
     D MaxNoAnalCd     C                   CONST(999)
 
      ** Analysis Code
     D #_ANAL          S              2    DIM(MaxNoAnalCd)
 
      ** Other field used
     D WRun            S              1A
     D @IX             S              3S 0 INZ(*ZERO)
 
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Extract Analysis Code Driver File
     C                   EXSR      SRExtrANAL
 
     C                   EVAL      *INLR  = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrANAL  - Extract Analysis Code Data                     *
      *                                                               *
      *****************************************************************
 
     C     SRExtrANAL    BEGSR
 
     C     *LOVAL        SETLL     SDTICSL1
     C                   READ      SDTICSL1
     C                   DOW       NOT %EOF(SDTICSL1)
 
     C                   IF        TCANAL <> ' '
 
     C     TCANAL        LOOKUP    #_ANAL(1)                              99
     C                   IF        *IN99 = *OFF
     C                   EVAL      @IX = @IX + 1
     C                   EVAL      #_ANAL(@IX) = TCANAL
 
     C                   EVAL      T1MTYP   = TCTYLC
     C                   EVAL      T1ANAL   = TCANAL
 
      ** Write to Extract Analysis Code
     C                   WRITE     TIANCDD0
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDTICSL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
