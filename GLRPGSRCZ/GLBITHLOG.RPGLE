     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Header Support Log Setup Module')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHLOG - JE header Support Log Setup Module               *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             Journal Entry Header file into screen format      *
      *             to be used in writing records to the log file.    *
      *                                                               *
      *  (c) Misys International Banking System, Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7895            Date 18Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG711             Date 19Mar04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Hash Total and No. of Items added to     *
      *           Header input screen.  Recompiled only.              *
      *  BUG7895 - Action code field added to GLBITHPD (Recompiled)   *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG711 - Recompiled due to change in GLBITHPD                *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *pssr - Error processing                                      *
      * *inzsr - Initialization                                       *
      *                                                               *
      *    The *inzsr subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
     D BITHFilFmt    E DS                  EXTNAME(GLJENHPD)
      ** JE Header details in file format
 
     D BITHScnFmt    E DS                  EXTNAME(GLBITHPD)
      ** JE Header details in screen format
 
     D ExtDataDS     E DS                  EXTNAME(GLBHEXPD)
      ** API BITH extra data layout file
 
      ** DS for hash total and hash decimals
     D BatchTotDS      DS
     D    WBInt                1     15
     D    WBDec               16     18
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A
 
      ** Define variables used by ZEDIT module
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Execute detail processing
     C                   EXSR      SRPROC
 
      ** End of program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Detail processing                                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: ZEDIT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise Transaction Detail and Extension data fields
     C                   CLEAR                   TRANSDTL
     C                   CLEAR                   ExtDataDS
 
      ** Fill the screen fields with the received values
      ** from GLBITHUPD
     C                   EVAL      DDBCDA = BRBCDA
     C                   EVAL      DDDPCD = BRDPCD
     C                   EVAL      DDMBRB = BRMBRB
     C                   EVAL      DDBDES = BRBDES
     C                   IF        BRBTSF = 'H'
     C                             AND BRBHAI = *BLANKS
     C                   EVAL      DDBHAI = BRBTSF
     C                   ELSE
     C                   EVAL      DDBHAI = BRBHAI
     C                   ENDIF
 
      ** Convert unsigned numeric fields into screen format
     C                   MOVE      BRHIIN        WBInt
     C                   MOVE      BRHDIN        WBDec
     C                   MOVE      BatchTotDS    ZFIELD
     C                   EVAL      ZADEC = 3
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
      ** Converted value is now in screen format so we're now ready
      ** to fill the missing fields in GLBITHPD file
     C                   MOVE      ZFIELD        DDFMAM
     C                   MOVE      BRHINI        DDNOIS
 
      ** Set the value of TRANSDTL to be returned to GLBITHUPD module.
      ** This data structure will be used by APLOGTRAN in writing to
      ** the standard API log file.
     C                   EVAL      TRANSDTL = BITHScnFmt + ExtDataDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly called on program activation            *
      *                                                               *
      * Calls: AOBANKR0 - Bank details                                *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
      ** Input/Output Parameters:
      ** ========================
      ** Return Code
      ** JE Header details in file format
      ** Transaction details
 
     C     *entry        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    BITHFilFmt
     C                   PARM                    TRANSDTL
 
      ** Initialise field for error processing
     C                   EVAL      DBPgm = 'GLBITHLOG'
 
      **--------------------------------------------------------------+
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking systems, Ltd. 2001
