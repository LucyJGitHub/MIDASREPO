     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Retail Interest Summary - Driver')            *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7010 - Retail Interest Summary (Driver)                    *
      *                                                               *
      *  Function:  This program reads the Interest Summary           *
      *  (COB)      extension file and calls the extract              *
      *             program for each statement required.              *
      *                                                               *
      *  Called By: CGC2050-00030 (COB-component)                     *
      *             -> CGC7010 -> CG7010 driver--> CG7020 extract     *
      *                                                               *
      *  (C) COPYRIGHT Finastra International Limited                 *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER039 *CREATE     Date 03May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER039 - Retail Interest Summary Correspondence              *
      *           (Upgrade of German Features FGE092)                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ---------------                                              *
      *                                                               *
      *****************************************************************
     FREINSHPD  UF   E           K DISK
     F                                     INFSR(SRFILE)
 
     D/COPY CGCPYSRC,SRERRDLE
     D/COPY CGCPYSRC,CGAUDTDLE
 
      ** Parameter fields
     D UFRTCD          S              7A
     D UFCMT           S              3A
     D UFCOPD          S              1A
     D ##RTCD          S              7A
     D ##OPTN          S              7A
     D ##SARD          S              6A
     D W1RTN           S              7A
     D W1ACT           S              8A
     D W1RSQN          S              5A
     D W0RTN           S              7A
     D W0ACT           S              8A
     D W0CMT           S              3A
     D W0PATH          S            256A
     D W0TITL          S              7A
     D W0ULIN          S              7A
     D W0RSQN          S              5A
 
      ** Work fields
     D ##INIT          S              1A
     D Q               S              5P 0
     D ##DREC          S              5P 0
     D CCG015          S              1A
     D ##BIS           S             80A
 
     D DSPARM        E DS                  EXTNAME(REINSHPD)
      **  External DS for parameter passed to CG7020
 
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
 
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for Bank details
 
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
 
      **  Record format of PF/CGUDTAPD for use as a parameter
 
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                SRMAIN - Main Processing                       *
      *                SRAUDT - Audit Report Processing               *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT
     C                   ENDIF
      *
      ** Initialisation processing
     C                   EXSR      SRINZ
      *
      ** Main processing
     C                   EXSR      SRMAIN
      *
      ** Audit processing
     C                   EXSR      SRAUDT
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  CG7020 - Interest Summary (Extract)            *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      ** Read from the Retail Interest Summary extension file
      *
     C     *LOVAL        SETLL     REINSHPD
     C                   READ      REINSHPD                               99
      *
      ** Read until End of File
      *
     C     *IN99         DOWEQ     '0'
      *
      **  Increment the count of REINSHPD records read.
     C                   ADD       1             ##DREC
      *
      **  If Statement required
     C     FSRQD         IFEQ      'Y'
      *
      ** Produce Statement
     C                   CALL      'CG7020 '
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      W0CMT         UFCMT
     C                   PARM      *BLANK        UFCOPD
     C                   PARM                    DSPARM
      *
      **  Error in called program.
     C     UFRTCD        IFNE      *BLANK
      *
     C                   EXSR      SRAUDT
      *
      ** Database error
     C                   MOVEL     'CG7010  '    W0FILE                         ***************
     C                   MOVEL     UFRTCD        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Statement Produced?
     C     UFCOPD        IFNE      'N'
      *
      ** Update Statement Required Indicator on REINSHPD
     C                   MOVEL     'N'           FSRQD
      *
     C                   UPDATE    REINSHD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record from REINSHPD
      *
     C                   READ      REINSHPD                               99
     C                   ENDDO
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINZ                                          *
      * Function    :  Initialise Fields on Program Invocation        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  CGZAUDIT - Audit Processing                    *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      *................................................................
      *
      **  Open the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7010AU'    I#SPLN
     C                   MOVEL     'CG7010  '    I#REF
     C                   MOVE      'CGD3014'     I#TITL
     C                   MOVE      'CGD3015'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN
      *
      *................................................................
      *
     C     EXINZ         TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      ** CALL ACCESS PROGRAM FOR BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     02            W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Check Correspondence Module is switched ON.
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      ##SARD
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CCG015
     C                   ELSE
     C                   MOVEL     'N'           CCG015
     C                   END
      *
      **  Initialise work fields
     C                   Z-ADD     *ZEROS        ##DREC
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRAUDT                                         *
      * Function    :  Audit Report Processing                        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  CGZAUDIT - Audit Processing                    *
      *                CG9020   - Write Data to UDC Data Files - Audit*
      *****************************************************************
     C     SRAUDT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRAUDT'      @STK(Q)
      *
      *................................................................
 
      **  Output the Count of records read
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7010  '    I#REF
     C                   MOVE      'CGD3014'     I#TITL
     C                   MOVE      'CGD3015'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C                   MOVEL     'REINSHPD'    I#SUB
     C                   MOVEL     'CGD3013'     I#TEXT
     C                   Z-ADD     ##DREC        I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVE      '1'           I#EDIT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN
      *
      **  Skip a line.
     C                   MOVE      '*SKIP   '    W1ACT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN
      *
     C     CCG015        IFEQ      'N'
      *
      **  Produce the Audit Report.
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*AUDIT  '    W0ACT
     C                   PARM      *BLANKS       W0PATH
     C                   PARM                    W0FMT
     C                   PARM      'CGD3014'     W0TITL
     C                   PARM      'CGD3015'     W0ULIN
     C                   PARM                    W0CMT
      *
     C                   ENDIF
      *
      **  Close the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7010  '    I#REF
     C                   MOVE      'CGD3014'     I#TITL
     C                   MOVE      'CGD3015'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN
      *................................................................
      *
     C     EXAUDT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     O/SPACE 5
**CTDATA ##CPY
(c) COPYRIGHT Finastra International Limited 2011
