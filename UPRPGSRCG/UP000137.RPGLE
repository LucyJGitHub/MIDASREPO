     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Add a rec if UPMRECPD has active parm.')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000137 - Add record to UPMODSPD if the creation parameter  *
      *             in UPIRECPD is active.                            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Called By: UPC000137                                         *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK022             Date 29Jul05               *
      *                 CUP029 *C *CREATE  Date 23Sep04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK022 - Should not use zone /COPYs.                         *
      *  CUP029 - Utility to cross check module and program sources   *
      *           in a library.                                       *
      *                                                               *
      *****************************************************************
      * Function of indicators                                        *
      *                                                               *
      *       20      End of file                                     *
      *       50      Scan string found                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FUPIRECPD  IF   E             DISK    INFSR(*PSSR)
      * RTV : Midsa UP Input records with creation parameters
      *
     FUPMODSPD  O    E             DISK    INFSR(*PSSR)
      * UPD : Midsa UP All module members in a library
      *
      /EJECT
      *****************************************************************
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D***/COPY*ZACPYSRC,PSDS*                                                                 CPK022
     D/COPY GPCPYSRCG,PSDS                                                                    CPK022
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Data structure for field in file UPIRECPD.
     D                 DS
     D  IRCPAR                 1    112
     D  CreateParm             1     90
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    SourceFile       10
     C                   PARM                    ModuleMbr        10
      *
     C                   EVAL      *IN50 = '0'
      *
      * Read first record from UPIRECPD ie, first line of creation parameters
      * with 'xxxBASEMODE' for a member.
     C                   READ      UPIRECPD                               20    EOF
      *
     C                   DOW       *IN20 = '0' AND                              EOF AND
     C                             *IN50 = '0'                                  '/*STD' not found
      *
     C     '/*STD '      SCAN      CreateParm                             50    ON if found
      *
     C  N50              READ      UPIRECPD                               20
      *
     C                   ENDDO                                                  OD *IN20 = '0' and
      *                                                                            *IN50 = '0'
      * If /*STD is found, add a record to UPMODSPD.
     C                   IF        *IN50 = '1'
     C                   EVAL      MLFILE = SourceFile
     C                   EVAL      MLNAME = ModuleMbr
     C                   WRITE     UPMODSD0
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
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
