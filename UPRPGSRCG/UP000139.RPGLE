     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Write UPSVPSMPD rec for each SVP modules')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000139 - Add records to UPSVPSMPD for each module listed   *
      *             in header box of a service program                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Called By: UPC000139                                         *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK022             Date 29Jul05               *
      *                 CUP029 *C *CREATE  Date 29Sep04               *
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
      *       50      Close bracket found                             *
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
     FUPSVPSMPD O    E             DISK    INFSR(*PSSR)
      * UPD : Midsa UP Service program member with related modules
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
     D IRCPAR                  1    112
     D ParmType                1      5
     D KeywordMod             10     16
     D CloseBracket           10     11
     D RelModFld              17     70
     D RelModules             17     70    DIM(54)
 
     D A_RelModules    S             10    DIM(10)
      * Array holding all modules from one header box line (one UPIRECPD record)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Fld_Indx        S              2  0                                      RelModules fld index
     D Arr_Indx        S              2  0                                      A_RelModules index
     D NoOfModEntry    S              2  0                                      No of modules Entry
     D                                                                          in A_RelModules
     D StartPos        S              2  0                                      Module start positio
 
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *                                                               *
      * Calls: LoadRelModAr                                           *
      *      : WrtSMRecs                                              *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    SourceFile       10
     C                   PARM                    SVPgmMbr         10
      *
     C                   EVAL      *IN50 = '0'
      *
      * Read first *EXI line for a service program
     C                   READ      UPIRECPD                               20    EOF
      *
     C                   DOW       *IN20 = '0' AND                              EOF AND
     C                             *IN50 = '0'                                  ') ' not found
      *
     C                   IF        KeywordMod = 'MODULE(' OR
     C                             KeywordMod = '       '
     C                   EXSR      LoadRelModAr
     C                   EXSR      WrtSMRecs
     C                   ELSE
     C                   IF        CloseBracket = ') '
     C                   SETON                                        50
     C                   ENDIF                                                  FI CloseBracket=') '
     C                   ENDIF                                                  FI
      *
     C  N50              READ      UPIRECPD                               20
      *
     C                   ENDDO                                                  OD *IN20 = '0' and
      *                                                                            *IN50 = '0'
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * LoadRelModAr - Load A_RelModules Array with modules in one    *
      *                input record.                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     LoadRelModAr  BEGSR
      *
     C                   EVAL      Fld_Indx  = 1
     C                   EVAL      Arr_Indx  = 0
     C                   EVAL      A_RelModules = *BLANK
      *
     C                   DOW       Fld_Indx  < 54
      *
      * Find the start of a module entry
     C                   DOW       RelModules(Fld_Indx) =  ' '  AND
     C                             Fld_Indx < 54
     C                   EVAL      Fld_Indx  = Fld_Indx + 1
     C                   ENDDO
      *
     C                   IF        Fld_Indx = 54
     C                   EVAL      NoOfModEntry = Arr_Indx
     C                   GOTO      LoadRelModArE
     C                   ENDIF
      *
     C                   EVAL      StartPos  = Fld_Indx
      *
      * Find the end of a module entry
     C                   DOW       RelModules(Fld_Indx) <> ' '  AND
     C                             Fld_Indx < 54
     C                   EVAL      Fld_Indx  = Fld_Indx + 1
     C                   ENDDO
      *
      * Load one A_RelModules entry
     C                   EVAL      Arr_Indx = Arr_Indx + 1
      *
     C                   EVAL      A_RelModules(Arr_Indx) = %SubSt(RelModFld:+
     C                               StartPos:Fld_Indx -StartPos)
      *
     C                   ENDDO                                                  OD Fld_Inx < 54
      *
     C                   EVAL      NoOfModEntry = Arr_Indx
      *
     C     LoadRelModArE ENDSR
      *
      *
      *****************************************************************
      *                                                               *
      * WrtSMRecs - Write records to UPSVPSMPD for each module in the *
      *             input line.                                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     WrtSMRecs     BEGSR
      *
     C                   EVAL      Arr_Indx  = 1
      *
     C                   EVAL      SVFILE = SourceFile
     C                   EVAL      SVPGM  = SVPgmMbr
      *
     C                   DOW       Arr_Indx <= NoOfModEntry
      *
     C                   EVAL      SVLMOD   = A_RelModules(Arr_Indx)
     C                   WRITE     UPSVPSMD0
      *
     C                   EVAL      Arr_Indx = Arr_Indx + 1
      *
     C                   ENDDO
      *
     C     WrtSMRecsE    ENDSR
      *
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
