     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('On-Line Synch of EQ data for Consumer Banking Ctrl')
      *****************************************************************
      *                                                               *
      *  Midas  - Global Processing Module                            *
      *                                                               *
      *  GOOLSYNGEC - Update On-line synchronisation of Equation data *
      *                                                               *
      *  Function:  Update On-line synchronisation of Equation data   *
      *             with Consumer Banking                             *
      *  Called By: GOC0104 - On-line synchronisation of Equation data*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14101           Date 19Jun07               *
      *  Prev Amend No. BUG13624           Date 23Mar07               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14101 - Background job EQ_ONL_SYN is generated errors     *
      *             and looping                                       *
      *  BUG13624 - Background job EQ_ONL_SYN is not running          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *    XX    -  Function of Indicator                             *
      *    99    -  Used for LOOKUP & CALL Operations                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Program exception error routine                  *
      *  *INZSR    - Initialisation Subroutine                        *
      *  WRTTE_LOG - Write to Log File Subroutine                     *
      *                                                               *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Log File for On-line Synchronization of Equation Data
     FGPESOLOGPDO  A E             DISK    INFSR(*PSSR)
     FGOEOSJSPD IF   E             DISK    INFSR(*PSSR)                                     BUG14101
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Data Structure for Data Area KAPJRN
     DKAPJRN           DS          2000
     DJRNNAM                  24     29
     DJRNLIB                  34     40                                                     BUG13624
     D #_RCV1          S              1    DIM(30) CTDATA PERRCD(30)
     D #_RCV2          S              1    DIM(240) CTDATA PERRCD(80)
     D RCVJRNE         S              1    DIM(2500)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @X              S              3  0 INZ(*ZEROS)
     D @T              S              5  0 INZ(*ZEROS)
     DWJRN             S             14A
     DWJRN1            C                   CONST('/')
     DWJRN2            S              8A
     DWJRNRCVR         S             10A                                                    BUG14101
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCCESSING                                                  *
      *********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    JRNSEQA          10
     C                   PARM                    JRNRCVR          10                        BUG14101
      *
      ** Move in files
      *
     C                   MOVEA     #_RCV1        RCVJRNE(1)
      *
      ** Add journal to used
      *
     C                   IN        KAPJRN
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99
     C                   MOVEL     JRNLIB        WJRN2                                      BUG13624
     C                   MOVE      WJRN1         WJRN2                                      BUG13624
     C                   MOVEL     WJRN2         WJRN                                       BUG13624
     C                   MOVE      JRNNAM        WJRN                                       BUG13624
     C                   MOVEA     WJRN          RCVJRNE(@T)                                BUG13624
     C**********         MOVEA     JRNNAM        RCVJRNE(@T)                                BUG13624
      *
      ** Preserve the index for the final string creation,
      *
     C                   EVAL      @X = @T
      *
      ** Find journal sequence number
      *
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    #_RCV2(@T)                             99
     C                   MOVEA     JRNSEQA       #_RCV2(@T)
      *
      ** Find end of command
      *
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    #_RCV2(@T)                             99
     C                   MOVEA     ' '           #_RCV2(@T)
      *
      ** Final command string,after adding both the compile time arrays
      *
     C**********         EVAL      @X = @X + 6                                              BUG13624
     C                   EVAL      @X = @X + 14                                             BUG13624
     C                   MOVEA     #_RCV2        RCVJRNE(@X)
      *
      ** Execute RCVJRNE
      *
     C                   Z-ADD     @T            #MesLen          15 5
     C                   Eval      WJRNRCVR = JRNRCVR                                       BUG14101
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    RCVJRNE
     C                   PARM                    #MesLen
      * If Journal Receiver have change pass it back                                        BUG14101
     C     1             CHAIN(E)  GOEOSJSPD                                                BUG14101
     C                   If        WJRNRCVR <> I#LASTRCV                                    BUG14101
     C                   EVAL      JRNRCVR = I#LASTRCV                                      BUG14101
     C                   SETON                                            U6                BUG14101
     C                   Endif                                                              BUG14101
      *
      ** 'Normal' return
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR -    Initialize Subroutine                             *
      *                                                               *
      *  Called By: Called automatically at program start             *
      *                                                               *
      *  Calls:     WRITE_LOG                                         *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
      *
      ** Job details
      *
     C                   EVAL      OSJOB  = PSJobName
     C                   EVAL      OSUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      OSJOBN = PSJobNoA
      *
      ** Record start of function
      *
     C                   EVAL      OSMSG = 'On-line Synchronisation to START'
     C                   EXSR      WRITE_LOG
     C     *DTAARA       DEFINE                  KAPJRN
     C                   ENDSR
 
      *****************************************************************
      *  WRITE_LOG -Write to the log file                             *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls:     None                                              *
      *****************************************************************
     C     WRITE_LOG     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      OSDATE
     C                   MOVEL     TimeDate      OSTIME
     C                   WRITE     GESOLOGD0
     C                   ENDSR
      *******************************************************************
      * *PSSR - Program exception error routine
      /COPY GOCPYSRC,GOPSSR
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**  #_RCV1
RCVJRNE JRN(!
**  #_RCV2
) FILE(SCPF OSPF) EXITPGM(GOOLSYNGEZ) RCVRNG(*CURCHAIN) FROMENT(!000000000)
JRNCDE((R) (C *IGNFILSLT) (U *IGNFILSLT) (J *IGNFILSLT)) ENTFMT(*TYPE1)
DELAY(*NEXTENT) !
