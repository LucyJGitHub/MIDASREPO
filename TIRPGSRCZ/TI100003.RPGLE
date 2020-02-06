     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI A/c Transfer Selected Accounts Extract')      *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI100003 - Midas TI Account Transfer Selected Accounts       *
      *             Extract                                           *
      *                                                               *
      *  Function: This program creates Standing Data Driver File     *
      *             Update for TI Account Branch Change               *
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
      * SRExtrSLAC - Extract TI SLACysis Code Driver File             *
      * *INZSR  - Initialisation sub-routine                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Account Transfer Selected Accounts
     FGLSLACPD  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas TI Account Transfer Selected Accounts
     FTISLACPD  O    E           K DISK    INFSR(*PSSR)
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Definition: First DS for Access Programs, Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Definition: Bank Details Accessed Via Access Program.
 
     D GLSLAC        E DS                  EXTNAME(GLSLACPD)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtcd           S              7
     D POptn           S              7
 
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
 
      ** Extract Account Transfer Selected Accounts
     C                   EXSR      SRExtrSLAC
 
     C                   EVAL      *INLR  = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrSLAC  - Extract Account Transfer Selected Accounts     *
      *                                                               *
      *****************************************************************
 
     C     SRExtrSLAC    BEGSR
 
     C     *LOVAL        SETLL     GLSLACPD
     C                   READ      GLSLACPD
     C                   DOW       NOT %EOF(GLSLACPD)
 
     C                   IF        WKPRCD = SLPRCD
     C                             AND SLFCNU = SLTCNU
     C                             AND SLFACO = SLTACO
     C                             AND SLFACS = SLTACS
     C                   WRITE     TISLACD0
     C                   ENDIF
 
     C                   READ      GLSLACPD
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
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
     C     *INZSR        BEGSR
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Retrieve Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set Process Date
      *
     C                   MOVEL     BJMRDT        WKPRCD            9
     C                   MOVE      BJMRDT        WKYEAR            2 0
      *
     C                   IF        WKYEAR < 72
     C     WKYEAR        ADD       2000          WKCCYY            4 0
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
     C                   MOVE      WKCCYY        WKPRCD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
