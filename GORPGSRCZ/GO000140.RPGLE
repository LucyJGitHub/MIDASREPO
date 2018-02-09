     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Data Dowload for TIPlusInputActive')          *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000140 - Global Processing Data Dowload for                *
      *             TIPlusInputActive                                 *
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
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPDWNLL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D Value           S             50
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C/COPY GOCPYSRC,GOUPD_PARM
      *
      * Run download record.  This simply writes the data from GODTACPD
      *  to GPDWNLPD so there is no actual processing.
     C                   IF        Key_Desc = 'TIPlusInputActive'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - ogram exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C     GPDWNLL0Key   KLIST
     C                   KFLD                    DLMSID
     C                   KFLD                    DLKEYD
      *
      * Update Global Processing download file.
     C                   Open      GPDWNLL0
     C                   EVAL      DLMSID = System_ID
     C                   EVAL      DLKEYD = Key_Desc
      *
     C     GPDWNLL0Key   SETLL     GPDWNLL0
     C     GPDWNLL0Key   CHAIN     GPDWNLL0                           11
     C                   EVAL      DLVAL = '0'
     C                   EVAL      DLMPGM = Maint_Program
     C                   EVAL      DLMPRM = Maint_Parms
     C                   EVAL      DLEPGM = Enq_Program
     C                   EVAL      DLEPRM = Enq_Parms
     C                   EVAL      DLUATH = Unauth_Ind
     C                   IF        *IN11 = *ON
     C                   WRITE     @DWNLL0
     C                   ELSE
     C                   ENDIF
     C                   Close     GPDWNLL0
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   SetOn                                        U7U8
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
