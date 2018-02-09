     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(GPWTRAPL0X) TOFILE(GPWTRAPL0) SHARE(*NO)         *
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP GPWTRAPPD Housekeeping')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP210010 - GPWTRAPPD Housekeeping                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD023876A          Date 30Apr14               *
      *                 MD023876           Date 30Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG4926 *CREATE    Date 18Nov04               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023876A - Wrong location of task split objects             *
      *  MD023876 - GOC210000 Performance Issues                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4926 - Global House-Keeping                               *
      *                                                               *
      *****************************************************************
     F***GPWTRAPL0XIP   F  249    15AIDISK    KEYLOC(103) INFSR(*PSSR)                      MD023876
     F***GPTRAPL0  IF   F  249    15AIDISK    KEYLOC(103) INFSR(*PSSR)                      MD023876
     F***GPWTRAPL0 UF   E           K DISK                INFSR(*PSSR)                      MD023876
     FGPWTRAPL0 UF   E           K DISK       PREFIX(C)                                     MD023876
     F                                        RENAME(GOTRAPD0:WTRAPD0)                      MD023876
     F                                        INFSR(*PSSR)                                  MD023876
                                                                                            MD023876
     FGPTRAPL0  IF   E           K DISK       RENAME(GOTRAPD0:TRAPD0)                       MD023876
     F                                        INFSR(*PSSR)                                  MD023876
                                                                                            MD023876
     F***GPWTRPDPD IF   E             DISK       USROPN                           MD023876 MD023876A
     FGOWTRPDPD IF   E             DISK       USROPN                                       MD023876A
     F                                        INFSR(*PSSR)                                  MD023876
 
     D RetainRecentRec...                                                                   MD023876
     D                 S               N   INZ                                              MD023876
     D PrevCTID        S                   INZ LIKE(CT_ID)                                  MD023876
     D TCCID           S                   INZ(*ALL'9')                                     MD023876
     D                                     LIKE(CT_CCID)                                    MD023876
     D True            C                   CONST(*ON)                                       MD023876
     D False           C                   CONST(*OFF)                                      MD023876
                                                                                            MD023876
     D LDA           E DS                  INZ EXTNAME(LDA)                                 MD023876
     D                                     DTAARA(LDA)                                      MD023876
                                                                                            MD023876
     I***GPWTRAPL0XNS  01                                                                   MD023876
     I**********                      103  117 0CT_ID                                       MD023876
     I**********                      231  240 0CT_CCID                                     MD023876
     I**********NS  **                                                                      MD023876
     I**********                      103  117 0NT_ID                                       MD023876
     I***GPTRAPL0  NS                                                                       MD023876
 
      * Delete records from GPWTRAPPD if:
      * (i) There is no equivalent record on GPTRAPPD
      * (ii) There is more than one record on GPWTRAPPD for the transaction id
      *      (but keep the most recent one)
 
     C*****CT_ID         CHAIN     GPTRAPL0                           99                    MD023876
     C******IN99         IFEQ      *ON                                                      MD023876
     C**********         Z-SUB     666           CT_CCID                                    MD023876
     C**********         EXSR      DELETE_ID                                                MD023876
     C**********         ELSE                                                               MD023876
     C*****NT_ID         IFNE      CT_ID                                                    MD023876
     C**********         EXSR      DELETE_ID                                                MD023876
     C**********         ENDIF                                                              MD023876
     C**********         ENDIF                                                              MD023876
                                                                                            MD023876
     C                   RESET                   PrevCTID                                   MD023876
                                                                                            MD023876
      ** Get last record key for this batch                                                 MD023876
                                                                                            MD023876
     C**********         OPEN      GPWTRPDPD                                      MD023876 MD023876A
     C                   OPEN      GOWTRPDPD                                               MD023876A
                                                                                            MD023876
     C*****1****         CHAIN     GPWTRPDPD                                      MD023876 MD023876A
     C**********         IF        NOT %FOUND(GPWTRPDPD)                          MD023876 MD023876A
     C     1             CHAIN     GOWTRPDPD                                               MD023876A
     C                   IF        NOT %FOUND(GOWTRPDPD)                                   MD023876A
                                                                                            MD023876
     C     *LOCK         IN        LDA                                                      MD023876
     C**********         EVAL      DBFILE = 'GPWTRPDPD'                           MD023876 MD023876A
     C                   EVAL      DBFILE = 'GOWTRPDPD'                                    MD023876A
     C                   EVAL      DBKEY = '*START'                                         MD023876
     C                   EVAL      DBASE = 1                                                MD023876
     C                   OUT       LDA                                                      MD023876
     C                   EXSR      *PSSR                                                    MD023876
                                                                                            MD023876
     C                   ELSE                                                               MD023876
     C     GPWTRAPK      SETGT     GPWTRAPL0                                                MD023876
     C                   ENDIF                                                              MD023876
                                                                                            MD023876
      ** Read in reverse order while there are still records for this batch                 MD023876
                                                                                            MD023876
     C                   READP     GPWTRAPL0                                                MD023876
     C                   DOW       NOT %EOF(GPWTRAPL0)                                      MD023876
     C                             AND CT_ID >= SCTID                                       MD023876
     C                             AND CT_ID <= ECTID                                       MD023876
                                                                                            MD023876
     C                   EVAL      RetainRecentRec = False                                  MD023876
                                                                                            MD023876
      ** Check if all records for this key will be deleted (i)                              MD023876
      ** or recent record of the group should be retained (ii)                              MD023876
                                                                                            MD023876
     C                   IF        CT_ID <> PrevCTID                                        MD023876
                                                                                            MD023876
     C     CT_ID         CHAIN     GPTRAPL0                                                 MD023876
     C                   IF        %FOUND(GPTRAPL0)                                         MD023876
     C                   EVAL      RetainRecentRec = True                                   MD023876
     C                   ENDIF                                                              MD023876
                                                                                            MD023876
     C                   EVAL      PrevCTID = CT_ID                                         MD023876
     C                   ENDIF                                                              MD023876
                                                                                            MD023876
     C                   IF        NOT RetainRecentRec                                      MD023876
     C                   DELETE    WTRAPD0                                                  MD023876
     C                   ENDIF                                                              MD023876
                                                                                            MD023876
     C                   READP     GPWTRAPL0                                                MD023876
     C                   ENDDO                                                              MD023876
                                                                                            MD023876
     C**********         CLOSE     GPWTRPDPD                                      MD023876 MD023876A
     C                   CLOSE     GOWTRPDPD                                               MD023876A
     C                   RETURN                                                             MD023876
      ************************************************************************
     C*****DELETE_ID     BEGSR                                                              MD023876
     C*****GPWTRAPK      KLIST                                                              MD023876
     C**********         KFLD                    CT_ID                                      MD023876
     C*****GPWTRAPK      SETLL     GOTRAPD0                                                 MD023876
     C*****GPWTRAPK      READE     GOTRAPD0                               99                MD023876
     C******IN99         DOWEQ     *OFF                                                     MD023876
     C*****T_CCID        IFNE      CT_CCID                                                  MD023876
     C**********         DELETE    GOTRAPD0                                                 MD023876
     C**********         ELSE                                                               MD023876
     C**********         UNLOCK    GPWTRAPL0                                                MD023876
     C**********         ENDIF                                                              MD023876
     C*****GPWTRAPK      READE     GOTRAPD0                               99                MD023876
     C**********         ENDDO                                                              MD023876
     C**********         ENDSR                                                              MD023876
      ************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
                                                                                            MD023876
     C     GPWTRAPK      KLIST                                                              MD023876
     C                   KFLD                    ECTID                                      MD023876
     C                   KFLD                    TCCID                                      MD023876
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
