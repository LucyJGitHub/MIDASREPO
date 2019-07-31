     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices Read function')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSRED - SE Market Price Browse                           *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the SE Prices File.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP060  *CREATE    Date 03Nov00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FUNCTION Securities Details File - by Security name
     FPRICEL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICEDF:PRICEDFX)
      * FUNCTION Securities Details File - if CAC005 is on use this file
     FSEPRICL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
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
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIALIZE OUTPUTS
      *
     C                   MOVE      *BLANKS       @ERRMS
     C                   MOVE      *BLANKS       @PSSN
     C                   MOVE      *BLANKS       @PCNM
     C                   MOVE      *BLANKS       @PMKT
     C                   MOVE      *BLANKS       @PBRA
     C                   MOVE      *BLANKS       @PBOK
     C                   MOVE      *BLANKS       @PRFC
     C                   MOVE      *BLANKS       @PPRT
     C                   MOVE      *BLANKS       @PTFR
      *
      * Check for user authority to browse if not multi-branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * Validate Customer Reference (for pointer)
      *
     C                   EXSR      VALCUS
      *
      * Read forwards
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * Read backwards
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH SEC PRICES DETAILS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C                   IF        CAC005 = 'Y'
     C     KEY1          SETGT     SEPRICD0
     C                   ELSE
     C     PRICEK        SETGT     PRICEDFX
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     PSSN          ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read next security price detail
     C                   IF        CAC005 = 'Y'
     C                   READ      SEPRICD0                               99
     C                   ELSE
     C                   READ      PRICEDFX                               99
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1002'     @ERRMS
      *
      * Else, return the security price detail read
      *
     C                   ELSE
     C                   EXSR      FMTSCN
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH SEC PRICES DETAILS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C                   IF        CAC005 = 'Y'
     C     KEY1          SETLL     SEPRICD0
     C                   ELSE
     C     PRICEK        SETLL     PRICEDFX
     C                   ENDIF
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     PSSN          ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      * Read previous security price
      *
     C                   IF        CAC005 = 'Y'
     C                   READP     SEPRICD0                               99
     C                   ELSE
     C                   READP     PRICEDFX                               99
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the security price detail read
      *
     C                   ELSE
      *
     C                   EXSR      FMTSCN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTSCN - Format Screen Details
      *****************************************************************
     C     FMTSCN        BEGSR
 
     C                   MOVEL     PSSN          @PSSN
     C*****PCNM*         IFNE      *ZEROS                                                     CSD027
     C     PCNM          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     PCNM          @PCNM
     C                   ELSE
     C                   MOVE      *BLANKS       @PCNM
     C                   END
     C                   MOVEL     PMKT          @PMKT
     C     PBRA          IFNE      *BLANKS
     C                   MOVEL     PBRA          @PBRA
     C                   ELSE
     C                   MOVE      *BLANKS       @PBRA
     C                   END
     C                   MOVEL     PBOK          @PBOK
     C                   MOVEL     PPRT          @PPRT
     C     CAC005        IFEQ      'Y'
     C                   MOVEL     PBCD          @PBOK
     C                   MOVEL     PRFC          @PRFC
     C                   ENDIF
      *
     C     PTFR          IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'
     C                   MOVE      FCR997        @PTFR
     C                   ELSE
     C                   MOVEL     PTFR          @PTFR
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALCUS - VALIDATE*CUSTOMER                                    *
      *****************************************************************
     C     VALCUS        BEGSR
 
      * Validate that the customer reference is numeric or blank.   *
     C**********         TESTN                   DDPCNM               98                      CSD027
     C**********         MOVE      DDPCNM        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   99                  CSD027
 
      * If Customer is blank, zero or a number, this is OK
     C*****DDPCNM        IFEQ      *BLANKS                                                    CSD027
     C******IN98         OREQ      '1'                                                        CSD027
     C******IN99         OREQ      '1'                                                        CSD027
     C**********         MOVE      DDPCNM        @@PCNM            6 0                        CSD027
     C                   MOVE      DDPCNM        @@PCNM            6                          CSD027
 
      * RETURN ERROR MESSAGE
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'MMA1142'     @ERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         ENDIF                                                                CSD027
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Key fields
      * Read Forwards
      * Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      * ICD
     C                   PARM                    CAC005            1
     C                   PARM                    BGN4ST            1
     C                   PARM                    FCR997            4
      * OUTPUT PARAMETERS :
      * Error meassage
      * Key fields
     C                   PARM                    @ERRMS            7
     C                   PARM                    @PSSN            10
     C                   PARM                    @PCNM            10
     C                   PARM                    @PMKT             1
     C                   PARM                    @PBRA             3
     C                   PARM                    @PBOK             2
     C                   PARM                    @PRFC             4
     C                   PARM                    @PPRT             2
     C                   PARM                    @PTFR             4
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSRED'   DBPGM
 
     C     KEY1          KLIST
     C                   KFLD                    DDPSSN
     C                   KFLD                    @@PCNM
     C                   KFLD                    DDPMKT
     C                   KFLD                    DDPBRA
     C                   KFLD                    DDPBOK
     C                   KFLD                    DDPRFC
     C                   KFLD                    DDPPRT
     C                   KFLD                    DDPTFR
 
     C     PRICEK        KLIST
     C                   KFLD                    DDPSSN
     C                   KFLD                    @@PCNM
     C                   KFLD                    DDPMKT
     C                   KFLD                    DDPBRA
     C                   KFLD                    DDPBOK
     C                   KFLD                    DDPPRT
     C                   KFLD                    DDPTFR
      *
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
