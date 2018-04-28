     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Access Hierarchy Link Record')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100602 - Access Hierarchy Link record                      *
      *                                                               *
      *  Function:  This program access the link records for a        *
      *             given hierarchy ID and child account ID.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 21Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      ** RE Cash Management Hierarchy Links - by child a/c
     FRECMHLL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management Hierarchy Links - by Link ID
     FRECMHLL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLD6)
 
      ** RE Zero Balancing/Sweeping Hierarchy Links by Link ID
     FREZSHLL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Group Account Hierarchy Links by Hierarchy ID
     FREGAHLL0  IF   E           K DISK    INFSR(*PSSR)
 
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
      *  SRCMHL - Access Cash Management Hierarchy Links              *
      *  SRZSHL - Access Cash Management Hierarchy Links              *
      *  SRGAHL - Access Cash Management Hierarchy Links              *
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                              CGL029
     D I_CACD          S             10  0                                                    CGL029
     D K_CACD          S             10  0                                                    CGL029
                                                                                              CGL029
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
 
      * Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
 
      * Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
 
      * Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
 
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
 
      ***  Access Cash Management Hierarchy Links
 
     C     X_OPTN        IFEQ      '*ALL   '
     C     X_OPTN        OREQ      '*ONLYCM'
     C                   EXSR      SRCMHL
     C                   MOVEL     CLLINK        I_LINK
     C                   ENDIF
 
     C     X_OPTN        IFEQ      '*ALL   '
     C     X_OPTN        OREQ      '*EXCLCM'
 
      ***  Access Zero Balancing/Sweeping Hierarchy Links
 
     C     I_HTYP        IFEQ      'ZS'
     C                   EXSR      SRZSHL
     C                   ENDIF
 
      ***  Access Group Account Hierarchy Links
 
     C     I_HTYP        IFEQ      'GA'
     C                   EXSR      SRGAHL
     C                   ENDIF
      *
     C                   ENDIF
 
      * Clear format not used
 
     C     I_HTYP        IFEQ      'GA'
     C                   CLEAR                   O_ZSHL
     C                   ELSE
     C                   CLEAR                   O_GAHL
     C                   ENDIF
 
      ***  Return.
 
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
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
 
     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL
      *
     C     K_CMHL        KLIST
     C                   KFLD                    K_HIER            9 0
     C                   KFLD                    K_CBRC            3
     C**********         KFLD                    K_CCUS            6 0                        CSD027
     C                   KFLD                    K_CCUS            6                          CSD027
     C                   KFLD                    K_CCCY            3
     C**********         KFLD                    K_CACD            4 0                        CGL029
     C                   KFLD                    K_CACD                                       CGL029
     C                   KFLD                    K_CASN            2 0
      *
     C     K_ZGHL        KLIST
     C                   KFLD                    K_HIER            9 0
     C                   KFLD                    K_LINK            9 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCMHL
      *****************************************************************
      *                                                               *
      *  SRCMHL - Access Cash Management Hierarchy Links              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCMHL        BEGSR
      *
     C                   MOVEL     I_HIER        K_HIER
     C                   MOVEL     I_LINK        K_LINK
 
     C                   MOVEL     I_CBRC        K_CBRC
     C                   MOVEL     I_CCUS        K_CCUS
     C                   MOVEL     I_CCCY        K_CCCY
     C                   MOVEL     I_CACD        K_CACD
     C                   MOVEL     I_CASN        K_CASN
      *
     C     I_LINK        IFNE      *ZERO
     C     K_ZGHL        CHAIN     RECMHLD6                           80
     C                   ELSE
     C     K_CMHL        CHAIN     RECMHLD0                           80
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C                   MOVEL     '*NOREC '     X_RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRZSHL
      *****************************************************************
      *                                                               *
      *  SRZSHL - Access Zero Balancing/Sweeping Hierarchy Links      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRZSHL        BEGSR
      *
     C                   MOVEL     I_HIER        K_HIER
     C                   MOVEL     I_LINK        K_LINK
      *
     C     K_ZGHL        CHAIN     REZSHLD0                           81
      *
     C     *IN81         IFEQ      *ON
     C                   MOVEL     '*NOREC '     X_RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRGAHL
      *****************************************************************
      *                                                               *
      *  SRGAHL - Access Group Account Hierarchy Links                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRGAHL        BEGSR
      *
     C                   MOVEL     I_HIER        K_HIER
     C                   MOVEL     I_LINK        K_LINK
      *
     C     K_ZGHL        CHAIN     REGAHLD0                           82
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
