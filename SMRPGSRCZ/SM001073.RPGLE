      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*XBI *  OVRDBF FILE(MACBRDDQT) TOFILE(MACUB1)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Rmv rdn menu items from MACBRDD pre MPlus')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001073 - Update MACBRDD for copied Midas users, pre-       *
      *             MidasPlus                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUP034  *CREATE    Date 20Dec06               *
      *  Last Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP034 - MidasPlus user data migration.                      *
      *                                                               *
      *****************************************************************
      *
     FMACBRDDQT UF   E           K DISK    INFSR(*PSSR)
      *
     FMACBR     UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MACBRDDF:MACBRF) PREFIX(N)
     FGPMACBR   UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MACBRDDF:GMACBRF) PREFIX(G)
      *
     FSMSFCVL0  IF   E           K DISK    INFSR(*PSSR)
      *
     FGPMTXTL0  IF   E           K DISK    INFSR(*PSSR)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      *
     D                 DS
     D PrtLine                 1    100
     D  PrtPrf                 1     10
     D  PrtIndex              13     22
     D  PrtGroup              13     16  0
     D  PrtGroupA             13     16
     D  PrtCode               18     21
     D  PrtBranch             25     27
     D  PrtDesc               30     74
     D  PrtReason             77     96
      *
     D                 DS
     D ActionCodes1            1     10
     D  Code1_01               1      1
     D  Code1_02               2      2
     D  Code1_03               3      3
     D  Code1_04               4      4
     D  Code1_05               5      5
     D  Code1_06               6      6
     D  Code1_07               7      7
     D  Code1_08               8      8
     D  Code1_09               9      9
     D  Code1_10              10     10
      *
     D                 DS
     D ActionCodes2            1     10
     D  Code2_01               1      1
     D  Code2_02               2      2
     D  Code2_03               3      3
     D  Code2_04               4      4
     D  Code2_05               5      5
     D  Code2_06               6      6
     D  Code2_07               7      7
     D  Code2_08               8      8
     D  Code2_09               9      9
     D  Code2_10              10     10
      *
     D Codes1          S              1    DIM(10)
     D Codes2          S              1    DIM(10)
      *
     D KeyMGRP         S              4  0
     D KeyICDE         S              4
     D KeyIndex        S             10
     D KeyUser         S             10
     D KeyBranch       S              3
     D Match           S              1
     D ActCodeChg      S              1
     D SpaceFound      S              1
     D Idx1            S              2  0
     D Idx2            S              2  0
     D Write           S              7    INZ('*WRITE')
     D Report          S              7    INZ('*REPORT')
     D Program         S             10    INZ('SM001073')
      *
     C     KeySMSFCV     KLIST
     C                   KFLD                    KeyMGRP
     C                   KFLD                    KeyICDE
      *
     C     KeyGPMTXT     KLIST
     C                   KFLD                    KeyIndex
      *
     C     KeyMACBR      KLIST
     C                   KFLD                    KeyUser
     C                   KFLD                    KeyIndex
     C                   KFLD                    KeyBranch
      *
     C     *LOVAL        SETLL     MACBRDDQT
     C                   READ      MACBRDDQT
      *
     C                   DOW       NOT(%EOF)
      *
     C                   IF        RECI = 'D'
     C                   EVAL      PrtLine = *blanks
      *
     C                   EVAL      KeyMGRP = MGRP
     C                   EVAL      KeyICDE = ICDE
      * Chain to the menu item conversion file using the old group and code.
     C     KeySMSFCV     CHAIN     SMSFCVL0
      * If not found on the conversion file then report ...
     C                   IF        NOT(%FOUND)
     C                   EVAL      PrtPrf    = USRP
     C                   EVAL      PrtBranch = BRCB
     C                   EVAL      PrtGroup  = MGRP
     C                   EVAL      PrtCode   = ICDE
     C                   EVAL      PrtDesc = *blanks
     C                   EVAL      PrtReason = 'No Conversion'
     C                   EXSR      WriteLine
     C                   ELSE
     C                   EVAL      KeyIndex = XXINDX
      * ... else check the menu items file for the new unique number.
     C     KeyGPMTXT     CHAIN     GPMTXTL0
     C                   IF        NOT(%FOUND) or
     C                             MIDEL = 'Y'
      * If unique number not found or the record has been logically deleted
      *  then report ...
     C                   EVAL      PrtPrf    = USRP
     C                   EVAL      PrtIndex  = KeyIndex
     C                   EVAL      PrtBranch = BRCB
     C                   IF        NOT(%FOUND)
     C                   EVAL      PrtReason = 'Not Found'
     C                   EVAL      PrtDesc = *blanks
     C                   ENDIF
     C                   IF        MIDEL = 'Y'
     C                   EVAL      PrtReason = 'Deleted'
     C                   EVAL      PrtDesc = MIINAR
     C                   ENDIF
     C                   EXSR      WriteLine
      * ... else check if combination of user, branch and combination already
      *  exists on the new MACBRDD.
     C                   ELSE
      * Check if menu unique belongs to global layer.
     C                   IF        %SUBST(MIINDX:1:2) = '*G'
     C                   EXSR      GlobalActions
     C                   ELSE
     C                   EXSR      ZoneActions
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MACBRDDQT
      *
     C                   ENDDO
      *
      * Write final report.
     C                   CALL      'UP008010'
     C                   PARM                    Report
     C                   PARM                    Program
     C                   PARM                    PrtLine
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      ********************************************************************
      *  WriteLine - Write report line                                   *
      ********************************************************************
      *
     C     WriteLine     BEGSR
      *
     C                   CALL      'UP008010'
     C                   PARM                    Write
     C                   PARM                    Program
     C                   PARM                    PrtLine
      *
     C     WriteLineE    ENDSR
      *
      /EJECT
      ********************************************************************
      *  GlobalActions - Check GPMACBRDD                                 *
      ********************************************************************
      *
     C     GlobalActions BEGSR
      *
     C                   EVAL      KeyUser = USRP
     C                   EVAL      KeyBranch = BRCB
     C     KeyMACBR      CHAIN     GPMACBR
     C                   IF        NOT(%FOUND)
      * If not found then write record ...
     C                   EXSR      WriteGPMACBR
     C                   ELSE
      * ... else compare Action Codes and update records.
     C                   EXSR      UpdateGPMACBR
     C                   ENDIF
      *
     C     GlobalActionsEENDSR
      *
      /EJECT
      ********************************************************************
      *  ZoneActions - Check MACBRDD                                     *
      ********************************************************************
      *
     C     ZoneActions   BEGSR
      *
     C                   EVAL      KeyUser = USRP
     C                   EVAL      KeyBranch = BRCB
     C     KeyMACBR      CHAIN     MACBR
     C                   IF        NOT(%FOUND)
      * If not found then write record ...
     C                   EXSR      WriteMACBR
     C                   ELSE
      * ... else compare Action Codes and update records.
     C                   EXSR      UpdateMACBR
     C                   ENDIF
      *
     C     ZoneActionsE  ENDSR
      *
      /EJECT
      ********************************************************************
      *  WriteMACBR - Write record to new MACBRDD                        *
      ********************************************************************
      *
     C     WriteMACBR    BEGSR
      *
     C                   EVAL      NRECI    = RECI
     C                   EVAL      NUSRP    = USRP
     C                   EVAL      NMGRP    = MGRP
     C                   EVAL      NICDE    = ICDE
     C                   EVAL      NBRCB    = BRCB
     C                   EVAL      NACA1    = ACA1
     C                   EVAL      NACA2    = ACA2
     C                   EVAL      NACA3    = ACA3
     C                   EVAL      NACA4    = ACA4
     C                   EVAL      NACA5    = ACA5
     C                   EVAL      NACA6    = ACA6
     C                   EVAL      NACA7    = ACA7
     C                   EVAL      NACA8    = ACA8
     C                   EVAL      NACA9    = ACA9
     C                   EVAL      NACA10   = ACA10
     C                   EVAL      NLCD     = 0
     C                   EVAL      NCHTP    = 'I'
     C                   EVAL      NLCT     = 0
     C                   EVAL      NINDX    = KeyIndex
     C                   EVAL      NZONE    = *blanks
     C                   WRITE     MACBRF
      *
     C     WriteMACBRE   ENDSR
      *
      /EJECT
      ********************************************************************
      *  WriteGPMACBR - Write record to new GPMACBRDD                    *
      ********************************************************************
      *
     C     WriteGPMACBR  BEGSR
      *
     C                   EVAL      GRECI    = RECI
     C                   EVAL      GUSRP    = USRP
     C                   EVAL      GMGRP    = MGRP
     C                   EVAL      GICDE    = ICDE
     C                   EVAL      GBRCB    = BRCB
     C                   EVAL      GACA1    = ACA1
     C                   EVAL      GACA2    = ACA2
     C                   EVAL      GACA3    = ACA3
     C                   EVAL      GACA4    = ACA4
     C                   EVAL      GACA5    = ACA5
     C                   EVAL      GACA6    = ACA6
     C                   EVAL      GACA7    = ACA7
     C                   EVAL      GACA8    = ACA8
     C                   EVAL      GACA9    = ACA9
     C                   EVAL      GACA10   = ACA10
     C                   EVAL      GLCD     = 0
     C                   EVAL      GCHTP    = 'I'
     C                   EVAL      GLCT     = 0
     C                   EVAL      GINDX    = KeyIndex
     C                   EVAL      GZONE    = *blanks
     C                   WRITE     GMACBRF
      *
     C     WriteGPMACBRE ENDSR
      *
      /EJECT
      ********************************************************************
      *  UpdateMACBR - Update MACBRDD if Action Codes are different      *
      ********************************************************************
      *
     C     UpdateMACBR   BEGSR
      *
      * Fill data structures with Action codes.
     C                   EVAL      Code1_01 = ACA1
     C                   EVAL      Code1_02 = ACA2
     C                   EVAL      Code1_03 = ACA3
     C                   EVAL      Code1_04 = ACA4
     C                   EVAL      Code1_05 = ACA5
     C                   EVAL      Code1_06 = ACA6
     C                   EVAL      Code1_07 = ACA7
     C                   EVAL      Code1_08 = ACA8
     C                   EVAL      Code1_09 = ACA9
     C                   EVAL      Code1_10 = ACA10
      *
     C                   EVAL      Code2_01 = NACA1
     C                   EVAL      Code2_02 = NACA2
     C                   EVAL      Code2_03 = NACA3
     C                   EVAL      Code2_04 = NACA4
     C                   EVAL      Code2_05 = NACA5
     C                   EVAL      Code2_06 = NACA6
     C                   EVAL      Code2_07 = NACA7
     C                   EVAL      Code2_08 = NACA8
     C                   EVAL      Code2_09 = NACA9
     C                   EVAL      Code2_10 = NACA10
      *
      * Check complete data structures.  If they are not the same then start
      *  comparing individual positions.
     C                   IF        ActionCodes1 <> ActionCodes2
      * Fill arrays.
     C                   EVAL      Idx1 = 1
     C                   EVAL      Idx2 = 1
     C                   DOU       Idx1 > 10
     C                   EVAL      Codes1(Idx1) = %SUBST(ActionCodes1:Idx1:1)
     C                   EVAL      Codes2(Idx2) = %SUBST(ActionCodes2:Idx2:1)
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDDO
      *
     C                   EVAL      Idx1 = 1
     C                   EVAL      Idx2 = 1
      *
     C                   DOU       Idx1 > 10
     C                   IF        Codes1(Idx1) <> *blank
     C                   DOU       Match = 'Y' or
     C                             Idx2 > 10
     C                   IF        Codes1(Idx1) = Codes2(Idx2)
     C                   EVAL      Match = 'Y'
     C                   ELSE
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDIF
     C                   ENDDO
     C                   IF        Match <> 'Y'
     C                   EVAL      ActCodeChg = 'Y'
     C                   EXSR      UpdateActCode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = 1
     C                   EVAL      Match = 'N'
      *
     C                   ENDDO
      *
     C                   IF        ActCodeChg = 'Y'
     C                   EVAL      ActCodeChg = 'N'
     C                   MOVEA     Codes2        ActionCodes2
     C                   EVAL      NACA1   = Code2_01
     C                   EVAL      NACA2   = Code2_02
     C                   EVAL      NACA3   = Code2_03
     C                   EVAL      NACA4   = Code2_04
     C                   EVAL      NACA5   = Code2_05
     C                   EVAL      NACA6   = Code2_06
     C                   EVAL      NACA7   = Code2_07
     C                   EVAL      NACA8   = Code2_08
     C                   EVAL      NACA9   = Code2_09
     C                   EVAL      NACA10  = Code2_10
     C                   UPDATE    MACBRF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     UpdateMACBRE  ENDSR
      *
      /EJECT
      ********************************************************************
      *  UpdateGPMACBR - Update GPMACBRDD if Action Codes are different  *
      ********************************************************************
      *
     C     UpdateGPMACBR BEGSR
      *
      * Fill data structures with Action codes.
     C                   EVAL      Code1_01 = ACA1
     C                   EVAL      Code1_02 = ACA2
     C                   EVAL      Code1_03 = ACA3
     C                   EVAL      Code1_04 = ACA4
     C                   EVAL      Code1_05 = ACA5
     C                   EVAL      Code1_06 = ACA6
     C                   EVAL      Code1_07 = ACA7
     C                   EVAL      Code1_08 = ACA8
     C                   EVAL      Code1_09 = ACA9
     C                   EVAL      Code1_10 = ACA10
      *
     C                   EVAL      Code2_01 = GACA1
     C                   EVAL      Code2_02 = GACA2
     C                   EVAL      Code2_03 = GACA3
     C                   EVAL      Code2_04 = GACA4
     C                   EVAL      Code2_05 = GACA5
     C                   EVAL      Code2_06 = GACA6
     C                   EVAL      Code2_07 = GACA7
     C                   EVAL      Code2_08 = GACA8
     C                   EVAL      Code2_09 = GACA9
     C                   EVAL      Code2_10 = GACA10
      *
      * Check complete data structures.  If they are not the same then start
      *  comparing individual positions.
     C                   IF        ActionCodes1 <> ActionCodes2
      * Fill arrays.
     C                   EVAL      Idx1 = 1
     C                   EVAL      Idx2 = 1
     C                   DOU       Idx1 > 10
     C                   EVAL      Codes1(Idx1) = %SUBST(ActionCodes1:Idx1:1)
     C                   EVAL      Codes2(Idx2) = %SUBST(ActionCodes2:Idx2:1)
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDDO
      *
     C                   EVAL      Idx1 = 1
     C                   EVAL      Idx2 = 1
      *
     C                   DOU       Idx1 > 10
     C                   IF        Codes1(Idx1) <> *blank
     C                   DOU       Match = 'Y' or
     C                             Idx2 > 10
     C                   IF        Codes1(Idx1) = Codes2(Idx2)
     C                   EVAL      Match = 'Y'
     C                   ELSE
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDIF
     C                   ENDDO
     C                   IF        Match <> 'Y'
     C                   EVAL      ActCodeChg = 'Y'
     C                   EXSR      UpdateActCode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      Idx1 = Idx1 + 1
     C                   EVAL      Idx2 = 1
     C                   EVAL      Match = 'N'
      *
     C                   ENDDO
      *
     C                   IF        ActCodeChg = 'Y'
     C                   EVAL      ActCodeChg = 'N'
     C                   MOVEA     Codes2        ActionCodes2
     C                   EVAL      GACA1   = Code2_01
     C                   EVAL      GACA2   = Code2_02
     C                   EVAL      GACA3   = Code2_03
     C                   EVAL      GACA4   = Code2_04
     C                   EVAL      GACA5   = Code2_05
     C                   EVAL      GACA6   = Code2_06
     C                   EVAL      GACA7   = Code2_07
     C                   EVAL      GACA8   = Code2_08
     C                   EVAL      GACA9   = Code2_09
     C                   EVAL      GACA10  = Code2_10
     C                   UPDATE    GMACBRF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     UpdateGPMACBREENDSR
      *
      /EJECT
      ********************************************************************
      *  UpdateActCode - Find first space in Action Code array which is  *
      *                  blank and update it.                            *
      ********************************************************************
      *
     C     UpdateActCode BEGSR
      *
     C                   EVAL      Idx2 = 1
     C                   EVAL      SpaceFound = 'N'
      *
      * Check array for blank space.
     C                   DOU       SpaceFound = 'Y' or
     C                             Idx2 > 10
     C                   IF        Codes2(Idx2) = *blank
     C                   EVAL      Codes2(Idx2) = Codes1(Idx1)
     C                   EVAL      SpaceFound = 'Y'
     C                   ELSE
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If no space was found then report this as a problem.
     C                   IF        SpaceFound <> 'Y'
     C                   EVAL      ActCodeChg = 'N'
     C                   EVAL      PrtPrf    = USRP
     C                   EVAL      PrtIndex  = KeyIndex
     C                   EVAL      PrtBranch = BRCB
     C                   EVAL      PrtDesc = MIINAR
     C                   EVAL      PrtReason  = 'Action Code issue'
     C                   EXSR      WriteLine
     C                   ENDIF
     C
     C     UpdateActCodeEENDSR
      *
      /EJECT
      ********************************************************************
      *  *PSSR Subroutine - Error handling                               *
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
