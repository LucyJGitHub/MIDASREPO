     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Access Hierarchy Detail Record')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100601 - Access Hierarchy Detail record                    *
      *                                                               *
      *  Function:  This program access the detail records for a      *
      *             given hierarchy ID.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 214360             Date 03Feb03               *
      *  Prev Amend No. CRE008  *CREATE    Date 21Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      ** RE Cash Management Hierarchy Details - by Hierarchy ID
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Zero Balancing/Sweeping Hierarchy Details by Hierarchy ID
     FREZSHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Group Account Hierarchy Details by Hierarchy ID
     FREGAHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   80  - Record not found                                      *
      *   81  - Record not found                                      *
      *   82  - Record not found                                      *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *  SRCMHD - Access Cash Management Hierarchy Details            *
      *  SRZSHD - Access Cash Management Hierarchy Details            *
      *  SRGAHD - Access Cash Management Hierarchy Details            *
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
 
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
      * Cash Management Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
 
      * Zero Balancing/Sweeping Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
 
      * Group Account Hierarchy Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      *** Option must be valid
 
     C     X_OPTN        IFNE      '*ALL   '
     C     X_OPTN        ANDNE     '*ONLYCM'
     C     X_OPTN        ANDNE     '*EXCLCM'
     C                   EVAL      X_ERMS = 'BAD OPTION:' + X_OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ***  Access Cash Management Hierarchy details
 
     C     X_OPTN        IFEQ      '*ALL   '
     C     X_OPTN        OREQ      '*ONLYCM'
     C                   EXSR      SRCMHD
     C                   MOVEL     CDHTYP        I_HTYP
     C                   ENDIF
 
     C     X_OPTN        IFEQ      '*ALL   '
     C     X_OPTN        OREQ      '*EXCLCM'
 
      ***  Access Zero Balancing/Sweeping Hierarchy details
 
     C     I_HTYP        IFEQ      'ZS'
     C                   EXSR      SRZSHD
     C                   ENDIF
 
      ***  Access Group Account Hierarchy details
 
     C     I_HTYP        IFEQ      'GA'
     C                   EXSR      SRGAHD
     C                   ENDIF
      *
     C                   ENDIF
 
      * Clear format not used
 
     C     I_HTYP        IFEQ      'GA'
     C                   CLEAR                   O_ZSHD
     C                   ELSE
     C                   CLEAR                   O_GAHD
     C                   ENDIF
 
      *** Return.
 
     C                   RETURN
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Receive Parameter List.
      *
     C     *ENTRY        PLIST
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Option
     C                   PARM                    X_OPTN            7
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM                    I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCMHD
      *****************************************************************
      *                                                               *
      *  SRCMHD - Access Cash Management Hierarchy details            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCMHD        BEGSR
      *
     C     I_HIER        CHAIN     RECMHDL0                           80
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     '*NOREC '     X_RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRZSHD
      *****************************************************************
      *                                                               *
      *  SRZSHD - Access Zero Balancing/Sweeping Hierarchy Details    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRZSHD        BEGSR
      *
     C     I_HIER        CHAIN     REZSHDL0                           81
      *
     C     *IN81         IFEQ      *ON
     C                   MOVEL     '*NOREC '     X_RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRGAHD
      *****************************************************************
      *                                                               *
      *  SRGAHD - Access Group Account Hierarchy details              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRGAHD        BEGSR
      *
     C     I_HIER        CHAIN     REGAHDL0                           82
      *
     C     *IN82         IFEQ      *ON
     C                   MOVEL     '*NOREC '     X_RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE 5
      *******************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
     C/COPY ZACPYSRC,RECMPSSR
      ****************************************************************
