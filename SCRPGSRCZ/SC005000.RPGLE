     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Midas clustering - exit processing')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC005000 - Midas Clustering Exit Processing                  *
      *                                                               *
      *  Function:  This program is submitted by OS/400 Cluster       *
      *  Resource Services during different phases of a cluster       *
      *  environment.  It is designed to be used in conjunction       *
      *  with a Midas application Cluster Resource Group (CRG).       *
      *                                                               *
      *  Called By: OS/400 Cluster Resource Services                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 203053             Date 15Feb02               *
      *                 203048             Date 15Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSC013  *CREATE    Date 05Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  203053 - For action 'switchover' delay job until data CRG    *
      *           is available (QCSTHAAPPO position 51 is 'A').
      *  203048 - Clustering data areas are in xxDPLIB, not xxDTALIB. *
      *  CSC013 - Midas Clustering Feature                            *
      *           - New program for this feature.                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    77         Error in data area retrieval (QXXRTVDA)         *
      *    78         Error in QCMDEXEC                               *
      *    85         On = This is primary node in cluster.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
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
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      * Register Cancel Handler
      *
     D RegCnlHdlr      PR                  ExtProc('CEERTX')
     D  HdlrPtr                        *   ProcPtr
     D                                     Const
     D  CommAreaPtr                    *   Options(*Omit)
     D                                     Const
     D  FeedBack                     12    Options(*Omit)
      *
      * Register Condition Handler
      *
     D RegCndHdlr      PR                  ExtProc('CEEHDLR')
     D  HdlrPtr                        *   ProcPtr
     D                                     Const
     D  CommAreaPtr                    *   Const
     D  FeedBack                     12    Options(*Omit)
      *
      * UnRegister Cancel Handler
      *
     D UnRegCnlHdlr    PR                  ExtProc('CEEUTX')
     D  HdlrPtr                        *   ProcPtr
     D                                     Const
     D  FeedBack                     12    Options(*Omit)
      *
      * UnRegister Condition Handler
      *
     D UnRegCndHdlr    PR                  ExtProc('CEEHDLU')
     D  HdlrPtr                        *   ProcPtr
     D                                     Const
     D  FeedBack                     12    Options(*Omit)
      *
      * Cancel Handler
      *
     D CnlHdl          PR
     D  CommAreaPtr                    *   Options(*Omit)
     D                                     Const
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * User Information
      *
     D UserInf         DS          9000
     D  #InfLength                    9B 0
     D  #ClusterName                 10
     D  #CRGName                     10
     D  #CRGType                      9B 0
     D  #CRGStatus                    9B 0
     D  #RqtHdl                      16
     D  #NodeRoleType                 9B 0
     D  #CurrNodeID                   8
     D  #ChgNodeID                    8
     D  #ChgNodeRole                  9B 0
     D  #TakeoverIP                  16
     D  #JobName                     10
     D  #Reserved                     2
     D  #CRGChanges                   6
     D  #PriorActCode                 6
     D  #OffRcvyDom                   9B 0
     D  #NumNodes                     9B 0
     D  #RcvyDom                     16    DIM(300)
      *
      * Node Information
      *
     D NodeInf         DS
     D  #NodeId                       8
     D  #NodeRole                     9B 0
     D  #MemStatus                    9B 0
      *
      * Communication area for condition handler
      *
     D CommArea        DS
     D  Fld1                         10
     D  Fld2                         10
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      *  External DS for SAR details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
      * Condition handler Pointer
     D CndHdlrPtr      S               *   ProcPtr
     D                                     Inz( %Paddr( 'SC005010' ) )
      * Stand alone variable definitions
     D SuccessInd      S              9B 0
     D ActionCode      S              9B 0
     D PRID            S             10
     D X               S              9B 0
     D zz              S              9B 0
     D Int             S             10I 0
     D PgmName         S             10    INZ('*SYSTEM')
     D #Event          S              5  0
     D #AppFlag        S              1
     D dta_off         S              9B 0
     D dta_len         S              9B 0
     D dta_data        S           2000
     D data_area       S             20
     D #Data_Flag      S              1
     D #AppCrgO        S             10
     D #MsgReply       S              1
      *
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
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
      *
      * Register cancel handler
      *
     C                   callp     RegCnlHdlr( %paddr('CNLHDL') :
     C                                         *Omit            :
     C                                         *Omit)
      *
      * Register condition handler
      *
     C                   callp     RegCndHdlr( CndHdlrPtr       :
     C                                         %Addr(CommArea)  :
     C                                         *Omit)
      *
     C                   eval      SuccessInd = 0
     C                   z-add     ActionCode    #Event
      *
      * Check if current node is a primary node.
      *
     C                   move      *ON           *IN85
     C                   eval      zz = 0
      *
     C                   Do        #NumNodes     X
      *
     C                   Eval      NodeInf =
     C                                 %subst(UserInf:#OffRcvyDom+zz+1:16)
     C                   eval      zz = X * 16
      *
     C                   If        #CurrNodeId = #NodeID and
     C                               #NodeRole <> 0
      *
     C                   Eval      *in85 = '0'
     C                   Leave
      *
     C                   Endif
      *
     C                   Enddo
      *
      * Set Application Data Area Flag ONLY if called by Application CRG
      *
     C                   If        #CRGType = 2
      *
      * Set Application data area QCSTHAAPPI to "in use" when starting the
      * application CRG.
      * If action code is '2' (starting),
      *
     C                   If        #Event = 2
      *
      * If this is the primary node, then set application to "in use" ('I').
      * If primary node then set application to "in use" else application
      * is set to "available"
      *
     C                   If        *in85 = '1'
      *
     C                   eval      #AppFlag = 'I'
      *
      * Check for data being available 20 times and then carry on.
      *
     C                   do        20
      *
      **Get*QCSHAAPPO*data*area*to*determine*when*to*start*application.****                   203053
      * Get QCSTHAAPPO data area to determine when to start application.                      203053
      *
     C                   exsr      getDtaara
      *
      * If current status of the data flag is "available" ('A'),
      *
     C                   If        #Data_Flag = 'A'
      *
      * execute subroutine 'StartMidas'.
      *
     C                   Exsr      StartMidas
      *
      * Update the data area with the new value of the application flag,
      * "In Use" ('I').
      *
     C                   clear                   CMD
     C                   eval      CMD = 'CHGDTAARA DTAARA(' +
     C                             %trimr(Dta_Lib) + '/QCSTHAAPPI (425 1))   ' +
     C                               'VALUE(' + '''' + #AppFlag + '''' + ')'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
     C                   leave
      *
     C                   endif
      *
      * Delay job for 30 seconds before trying again.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'DLYJOB DLY(30)'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
     C                   enddo
      *
      * If this is not the primary node,
      *
     C                   else
     C                   eval      #AppFlag = 'A'
      *
     c                   endif
      *
     C                   endif
      *
      * Set Application data area QCSTHAAPPI to "available" when ending
      * If action code is '4' (Ending CRG),
      *
     C                   If        #Event = 4
      *
      * execute subroutine 'EndMidas' to terminate Midas system.
      *
     C                   Exsr      EndMidas
      *
      * Change the application flag to "Available" ('A').
      *
     C                   eval      #AppFlag = 'A'
      *
      * Update the data area QCSTHAAPPI, position 425.
      *
     C                   eval      CMD = 'CHGDTAARA DTAARA(' +
     C                             %trimr(Dta_Lib) + '/QCSTHAAPPI (425 1))   ' +
     C                               'VALUE(' + '''' + #AppFlag + '''' + ')'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
     C                   endif
      *
      * Set Application data area QCSTHAAPPI to "available" on backup nodes
      * when rejoining.
      * If action code is '8' (node is joining),
      *
     C                   If        #Event = 8
      *
      * and if node is a backup node,
      *
     C                   If        *in85 = '0'
      *
      * Change the application flag to "Available" ('A').
      *
     C                   eval      #AppFlag = 'A'
      *
      * Update the data area QCSTHAAPPI, position 425.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'CHGDTAARA DTAARA(' +
     C                             %trimr(Dta_Lib) + '/QCSTHAAPPI (425 1))   ' +
     C                               'VALUE(' + '''' + #AppFlag + '''' + ')'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
     C                   endif
      *
     C                   endif
      *
      * Set data area to "available" when switchover occurs.
      * If action code is '10' (Switch Primary),
      *
     C                   If        #Event = 10
      *
      * execute subroutine 'EndMidas' to terminate Midas system.
      *
     C                   Exsr      EndMidas
      *
      * Change the application flag to "Available" ('A').
      *
     C                   eval      #AppFlag = 'A'
      *
      * Update the data area QCSTHAAPPI, position 425.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'CHGDTAARA DTAARA(' +
     C                             %trimr(Dta_Lib) + '/QCSTHAAPPI (425 1))   ' +
     C                               'VALUE(' + '''' + #AppFlag + '''' + ')'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *                                                                                       203053
      * If this is the primary node,                                                          203053
      *                                                                                       203053
     C                   If        *in85 = '1'                                                203053
      *                                                                                       203053
      * Check for data being available 20 times and then carry on.                            203053
      *                                                                                       203053
     C                   do        20                                                         203053
      *                                                                                       203053
      * Get QCSHAAPPO data area to determine when to start application.                       203053
      *                                                                                       203053
     C                   exsr      getDtaara                                                  203053
      *                                                                                       203053
      * If current status of the data flag is "available" ('A'),                              203053
      *                                                                                       203053
     C                   If        #Data_Flag = 'A'                                           203053
      *                                                                                       203053
     C                   leave                                                                203053
      *                                                                                       203053
     C                   endif                                                                203053
      *                                                                                       203053
      * Delay job for 30 seconds before trying again.                                         203053
      *                                                                                       203053
     C                   clear                   CMD                                          203053
     C                   eval      CMD = 'DLYJOB DLY(30)'                                     203053
     C                   eval      C01LNG = %SIZE(CMD)                                        203053
     C                   call      'QCMDEXC'                            78                    203053
     C                   parm                    CMD             200                          203053
     C                   parm                    C01LNG           15 5                        203053
      *                                                                                       203053
     C                   enddo                                                                203053
      *                                                                                       203053
     C                   endif                                                                203053
      *
     C                   endif
      *
     C                   endif                                                  #CRGType = 2
      *
      * As long as this is the primary node,
      *
     C                   DoW       *In85 = '1'
      *
      * If the CRG is not an application CRG, exit.
      *
     C     #CRGType      IFNE      2
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
      * If action code is not a start or restart, exit.
      *
     C                   If        ActionCode <> 2 and
     C                               ActionCode <> 3
      *
     C                   Leave
      *
     C                   Endif
      *
      * If this is an application CRG and if this is the primary node,
      *
     C     #CRGType      ifeq      2
     C     *in85         Andeq     '1'
      *
      * execute a command to delay the job for 20 seconds.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'DLYJOB DLY(20)'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            78
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
     C                   endif
      *
     C                   enddo
      *
      * UnRegister the cancel handler.
      *
     C                   callp     UnRegCnlHdlr( %paddr('CNLHDL') :
     C                                           *Omit)
      *
      * UnRegister the condition handler
      *
     C                   callp     UnRegCndHdlr( CndHdlrPtr :
     C                                           *Omit)
      *
     C                   move      *ON           *INLR
     C                   return
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      * Entry Parameters
      *
     C     *ENTRY        plist
     C                   parm                    SuccessInd
     C                   parm                    ActionCode
     C                   parm                    ExitPgmData     256
     C                   parm                    UserInf
     C                   parm                    Format            8
      *
      *  Call AOSARDR0 to check that switchable feature CSC013, 'Midas
      *  Clustering', is on.
      *
     C                   callb     'AOSARDR0'
     C                   parm      *BLANKS       @RTCD             7
     C                   parm      '*VERIFY'     @OPTN             7
     C                   parm      'CSC013'      @SARD             6
     C     SCSARD        parm      SCSARD        DSFDY
      *
      *  If CSC013 is not on,
      *
     C     @RTCD         ifne      *BLANK
      *
      *  end the Midas system and terminate.
      *
     C                   exsr      EndMidas
     C                   exsr      *PSSR
      *
     C                   endif
      *
      *  Calculate the name of the system xxDTALIB, where the clustering
      *  data areas, QCSTHAAPPI and QCSTHAAPPO are located.
      *
      *  First retrieve the system ID from SDSTAT postions 6 and 7.
      *
     C                   clear                   Sys_Id            2
     C                   eval      dta_off = 6
     C                   eval      dta_len = 2
     C                   eval      data_area = 'SDSTAT    ' + '*LIBL     '
     C                   call      'QXXRTVDA'                           77
     C                   parm                    data_area
     C                   parm                    dta_off
     C                   parm                    dta_len
     C                   parm                    Sys_Id
     C
      *
      *  Calculate the library name.
      *
     C                   clear                   Dta_Lib          10
     C**********         eval      Dta_Lib = Sys_ID + 'DTALIB  '                              203048
     C                   eval      Dta_Lib = Sys_ID + 'DPLIB   '                              203048
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetDtaara subroutine                                          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: QXXRTVDA                                               *
      *                                                               *
      *****************************************************************
      *
     C     GetDtaara     begsr
      *
     C                   clear                   dta_data
     C                   eval      dta_off = 1
     C                   eval      dta_len = 2000
     C                   eval      data_area = 'QCSTHAAPPO' + Dta_Lib
     C                   call      'QXXRTVDA'                           77
     C                   parm                    data_area
     C                   parm                    dta_off
     C                   parm                    dta_len
     C                   parm                    dta_data
      *
      * Get data availability flag (postion 51).
      *
     C                   eval      #Data_Flag = %subst(dta_data:51:1)
     C                   eval      #AppCRGO = %subst(dta_data:25:10)
      *
      * If Data area QCSTHAAPPO doesn't exist then assume there are no
      * data CRGs and allow application to continue.
      *
     C**********         if        *in77 = '1' or #AppCrgO <> #CRGName                        203053
     C                   if        *in77 = '1'                                                203053
      *
     C                   eval      #Data_Flag = 'A'
      *
     C                   endif
      *
     C                   endsr
      *
      *******************************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EndMidas subroutine                                           *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: MIDASEND                                               *
      *                                                               *
      *****************************************************************
      *
     C     EndMidas      begsr
      *
      * Only do this on the Primary system or if a switchover is happening
      * and the current system is a backup system (The old primary)
      *
     C                   If        (#Event = 4 and *in85 = '1') or
     C                                (#Event = 10 and *in85 = '0')
      *
      * Call program 'SCC5020' to terminate Midas in a controled fashion.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'CALL PGM(SCC5020)'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            7878
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
      * Perform a dump for audit purposes.
      *
     C                   dump
      *
     C                   endif
      *
     C                   endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * StartMidas subroutine                                         *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: MIDASSTR                                               *
      *                                                               *
      *****************************************************************
      *
     C     StartMidas    begsr
      *
      * Call program 'SCC5030' to start up Midas in a controlled fashion.
      *
     C                   clear                   CMD
     C                   eval      CMD = 'CALL PGM(SCC5030)'
     C                   eval      C01LNG = %SIZE(CMD)
     C                   call      'QCMDEXC'                            7878
     C                   parm                    CMD             200
     C                   parm                    C01LNG           15 5
      *
     C                   endsr
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Procedure Cancel Handle                                    ***
      *****************************************************************
     P CnlHdl          B
 
     D CnlHdl          PI
     D  HdlrPtr                        *   Options(*Omit)
     D                                     Const
 
     C                   EVAL      SuccessInd = 0
 
     P CnlHdl          E
      *
