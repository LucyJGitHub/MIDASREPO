     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Take on of Stamp Tax Position Settlement')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008203 - Midas Take on of Stamp Tax Position Settlement    *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2011            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR821877 *CREATE   Date 05Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR821877 - Component SEC1112 00001 failed                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SE Position Settlements
     FPMPOSDL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Position Settlement Extension file
     FPOSETDY3  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Stamp Tax Customer Extension File
     FSDCUSQL0  IF A E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Branches Extension Acceptance File
     FSDBRCHEXL0IF A E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D U#BRCH          S              3A
     D U#CUST          S              6A
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      ** External DS for RUNDAT DataArea Layout file
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       %EOF(PMPOSDL4)
     C                   READ      PMPOSDL4
 
     C                   IF        NOT(%EOF(PMPOSDL4))
 
 
      ** Move Customer and branch into fields to CHAIN to files to see if
      ** liable to Stamp Tax.
 
     C                   MOVEL     PCPY          U#CUST
     C                   MOVEL     PBCA          U#BRCH
 
      ** Check Customer's Stamp Tax flag
 
     C                   EXSR      STCUS
 
      ** Check Branch Code's Stamp Tax flag
 
     C                   EXSR      STBRA
 
     ** Populated Stamp Tax fields
 
     C                   Z-ADD     BJRDNB        P3CDTE
 
     ** Stamp Tax Liable of Position Settlements will only be defaulted
     ** to 'Y' if both Customer and Branch are Stamp Tax Liable 'Y'
 
     C                   IF        W#CTAX = 'Y' AND W#BTAX = 'Y'
     C                   EVAL      P3TAX  = 'Y'
     C                   ELSE
     C                   EVAL      P3TAX  = 'N'
     C                   ENDIF
 
     C     KPOSETD       CHAIN     POSETDY3
     C                   IF        %FOUND(POSETDY3)
     C                   UPDATE    POSETDD3
     C                   ELSE
     C                   EVAL      P3PBCA = PBCA
     C                   EVAL      P3PSSH = PSSH
     C                   EVAL      P3PCPY = PCPY
     C                   EVAL      P3PEVT = PEVT
     C                   Z-ADD     PDUD          P3PDUD
     C                   Z-ADD     TNLU          P3TNLU
     C                   WRITE     POSETDD3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/STCUS - Check Customer's Stamp Tax  Flag                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     STCUS         BEGSR
 
     C     KLCUST        CHAIN     SDCUSQL0                           84
     C     *IN84         IFEQ      *OFF
     C     CQTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#CTAX            1
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#CTAX
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/STBRA - Check Branch Code's Stamp Tax  Flag                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     STBRA         BEGSR
 
     C     KLBRCH        CHAIN     SDBRCHEXL0                         83
     C     *IN83         IFEQ      *OFF
     C     BXTAX         IFEQ      'Y'
     C                   MOVE      'Y'           W#BTAX            1
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           W#BTAX
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key fields
 
     C     KPOSETD       KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
     C                   KFLD                    TNLU
 
     C     KLCUST        KLIST
     C                   KFLD                    U#CUST
 
     C     KLBRCH        KLIST
     C                   KFLD                    U#BRCH
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2011
