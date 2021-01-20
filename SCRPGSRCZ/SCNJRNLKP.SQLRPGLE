     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056887
/*STD *  RPGSQLBND                                                    *                     MD056887
/*EXI *  TEXT('Midas SC Files Not to be Journalled Lookup')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCNJRNLKP - Files not to be journalled lookup.               *
      *                                                               *
      *  Function:  This program looks up a file reference in the     *
      *             items not to be journalled file to be passed back *
      *             to CLPs SCC2464, SCC2467 and SCC2471.             *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD056887           Date 29Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6546  *CREATE   Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056887 - Deliverable Data Split for SCNJRNPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG6546 - Need to lookup file about to be journalled on      *
      *            SCNJRNL0, SCNJRNL1 or SCNJRNL2.                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Files not to be journalled view.
     F*SCNJRNL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056887

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

     D OKFILE          S             10
     D OKACTV          S              1

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SCNJRN        E DS                  EXTNAME(SCNJRJW0)                                MD056887
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************

      ** Look for object to be journalled in file.

     C                   EXSR      SRLookup

      ** Return

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLookup - Lookup file, dataarea or dataqueue.               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRLookup      BEGSR

      ** Check if file, dataarea or dataqueue is not to be journalled.

     C                   If        OKTYPE = *BLANKS                                         MD056887
     C                   eval      OKTYPE = '*FILE'                                         MD056887
     C                   Endif                                                              MD056887
     C*****SCNKEY        CHAIN     SCNJRNL0                           01                    MD056887
     C/EXEC SQL                                                                             MD056887
     C+ SELECT *                                                                            MD056887
     C+ into :SCNJRN                                                                        MD056887
     C+ from SCNJRJW0                                                                       MD056887
     C+ where NJFILE = :OKFILE and NJOTYP = :OKTYPE                                         MD056887
     C/END-EXEC                                                                             MD056887

      ** Journalling details not found

     C**********         IF        *IN01 = *ON                                              MD056887
     C                   IF        SQLCODE <> 0                                             MD056887
     C                   EVAL      OKACTV = 'N'
     C                   ELSE
     C                   EVAL      OKACTV = NJACTV
     C                   ENDIF

     C     EndLookup     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** File Name
     C                   PARM                    OKFILE

      ** Active flag
     C                   PARM                    OKACTV

      ** Obj Type                                                                           MD056887
     C                   PARM                    OKTYPE           10                        MD056887
                                                                                            MD056887
      ** Initialize program name
     C                   EVAL      DBPGM = 'SCNJRNLKP'

      ** Chaining key list.

     C     SCNKEY        KLIST
     C                   KFLD                    OKFILE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
