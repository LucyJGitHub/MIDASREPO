     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - Manual Transction')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000131 - Midas GO Download data control - Manual           *
      *             Transction                                        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 AR1009180 *CREATE  Date 25Nov12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  AR1009180 - Show unauthorized manual transaction in          *
      *              Midas dashboard (Child:AR1009182)                *
      *                                                               *
      *****************************************************************
 
     FGPMATRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      **
 
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
      ** Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                     134 141 DBFile
      **                                     142 170 DBKey
      **                                     171 180 DBPgm
      **                                     181 1830DBase
      **                                     184 193 DBMod
      **                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D Value           S             50
     D I#RTCD          S              7
     D I#ERMS          S             50
     D I#BRCD          S              3
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /COPY GOCPYSRC,GOUPD_PARM
 
      ** Get Zone Name from system ID.
 
     C     System_ID     CHAIN     GPZONED0                           90
 
      ** Unauthorised manual transaction
 
     C                   IF        Key_Desc = 'UnauthManualTrans'
 
      ** If the Midas phase is not Input Cycle then set data to blank
 
     C                   IF        MidasPhase <> 'A'
     C                   EVAL      Value = *BLANKS
     C                   ELSE
 
     C                   EVAL      CountN = 0
 
     C                   OPEN      GPMATRL0
     C     *LOVAL        SETLL     GPMATRL0
     C                   READ      GPMATRL0                               01
 
     C                   DOW       *IN01 = *OFF
     C                   CALL      'GPACSBRCH'
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM      MTBRCHCODE    I#BRCD
     C                   PARM                    GZSDBRCH
 
     C                   IF        A8ZONE = ZOZONE
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      GPMATRL0                               01
     C                   ENDDO
     C                   CLOSE     GPMATRL0
 
     C                   EVAL      Value = CountA
 
     C                   ENDIF
     C                   ENDIF
 
     C/COPY GOCPYSRC,GOUPD_DWNL
 
     C                   SETON                                        LR
     C                   RETURN
 
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
