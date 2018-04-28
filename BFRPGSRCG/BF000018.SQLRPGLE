     H DEBUG
     H NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas BF Permission Data Upload Common')
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000018 - Midas BF Permission Data Upload Common            *
      *                                                               *
      *  Function:  This program writes permission data into the      *
      *              BankFusion layer                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD019885  *CREATE  Date 04Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019885 - Permission upload interface                       *
      *           - Applied for MD026157                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  P R O C E D U R E  I N D E X                                 *
      *                                                               *
      *  GenArtefact   - Generate BFTB_RESOURCE record                *
      *  GenPermission - Generate BFTB_PERMISSION record              *
      *  MapArtfPerm   - Map BFTB_RESOURCE and BFTB_PERMISSION record *
      *  DelPermData   - Delete permission data across BF layer       *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Program Prototype                    ¦
      ** ¦ =================                    ¦
      ** +--------------------------------------+
      *
      * Permission Upload Routines
     D/COPY BFCPYSRCG,BF000008
      *
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Generate Menu Artefact Data          ¦
      ** ¦ ===========================          ¦
      ** +--------------------------------------+
      *
     P GENARTEFACT     B                   EXPORT
      *
     D GENARTEFACT     PI            10I 0
     D   MenuIndex                   10A   const
     D   ActionCode                   1A   const
     D   ArtefactName               256A   const
     D   ArtefactDesc               256A   const
      *
     D IdPk            S             20A
      /EJECT
      *
      /free
 
       IdPk = 'MI' + MenuIndex + ActionCode;
       // Create Record
 
        Exec SQL
            insert into BFTB_RESOURCE
            ( BFIDPK
            , BFARTEFACTID
            , BFENABLED
            , BFTYPE
            , BFDISPLAYNAME
            , BFDESCRIPTION
            , BFEXTERNALINVOCATION
            , BFSCMVERSION
            , BFLASTPUBLISHED
            , BFRESOURCEDATARUNTIME
            , BFACTIVATIONDATETIME
            , BFEXPIRYDATETIME
            , VERSIONNUM
            )
            values
            ( trim(replace(:Idpk, '*', ''))
            , trim(:ArtefactName)
            , 0
            , 101
            , trim(:ArtefactDesc)
            , trim(:ArtefactDesc)
            , 0
            , 'UNVERSIONED'
            , now()
            , BLOB('')
            , TIMESTAMP ('1970-01-01-08.00.00.000000')
            , TIMESTAMP ('1970-01-01-08.00.00.000000')
            , :VersionNum
            );
 
        RetCode = 0;
        If SQLCODE <> 0;
           RetCode = 1;
        EndIf;
 
       // End Procedure
 
               *INLR = '1';
               return RetCode;
 
      /end-free
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Generate Permission Data             ¦
      ** ¦ ===========================          ¦
      ** +--------------------------------------+
      *
     P GenPermission   B                   EXPORT
      *
     D GenPermission   PI            10I 0
     D   MenuIndex                   10A   const
     D   ActionCode                   1A   const
     D   PermSDesc                  256A   const
     D   PermLDesc                  256A   const
     D   PermType                     4A   const
     D   Module                     100A   const
      *
     D IdPk            S             20A
     D PermName        S            256A
      /EJECT
      *
      /free
 
       // Prepare Data
 
       IdPk = 'MI' + MenuIndex + ActionCode;
       PermName = 'MI_' + %trim(PermType) + '_' + MenuIndex + '_' + ActionCode;
 
       // Create Record
 
       Exec SQL
            insert into BFTB_PERMISSION
            ( BFIDPK
            , BFPERMISSIONNAME
            , BFLONGDESCRIPTION
            , BFSHORTDESCRIPTION
            , BFHOSTMODULEID
            , BFRECCREATEDBY
            , BFRECCREATEDON
            , BFRECSYSDATE
            , BFALLOWINOFFLINE
            , BFREADONLY
            , VERSIONNUM
            )
            values
            ( trim(replace(:Idpk, '*', ''))
            , trim(replace(:PermName, '*', ''))
            , trim(:PermLDesc)
            , trim(:PermSDesc)
            , trim(:Module)
            , 'system'
            , now()
            , now()
            , 0
            , 1
            , :VersionNum
            );
 
        RetCode = 0;
        If SQLCODE <> 0;
           RetCode = 1;
        EndIf;
 
       //  End Procedure
 
               *INLR = '1';
               return RetCode;
 
      /end-free
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Map Menu Artefact to Permission      ¦
      ** ¦ ===============================      ¦
      ** +--------------------------------------+
      *
     P MapArtfPerm     B                   EXPORT
      *
     D MapArtfPerm     PI            10I 0
     D   MenuIndex                   10A   const
     D   ActionCode                   1A   const
     D   ArtefactName               256A   const
      *
     D IdPk            S             20A
     D PermId          S             20A
      /EJECT
      *
      /free
 
       IdPk = 'MIRP' + MenuIndex + ActionCode;
       PermId = 'MI' + MenuIndex + ActionCode;
 
       Exec SQL
            insert into BFTB_RESOURCEPERM
            ( BFIDPK
            , BFRESOURCEID
            , BFPERMISSIONID
            , BFRECSYSDATE
            , BFRECCREATEDBY
            , BFRECCREATEDON
            , VERSIONNUM
            )
            values
            ( trim(replace(:Idpk, '*', ''))
            , trim(:ArtefactName)
            , trim(replace(:PermId, '*', ''))
            , now()
            , 'system'
            , now()
            , :VersionNum
            );
 
        RetCode = 0;
        If SQLCODE <> 0;
           RetCode = 1;
        EndIf;
 
       //  End Procedure
 
               *INLR = '1';
               return RetCode;
 
      /end-free
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Delete Permission Data               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
      *
     P DelPermData     B                   EXPORT
      *
     D DelPermData     PI            10I 0
     D   MenuIndex                   10A   const
     D   ActionCode                   1A   const
     D   ArtefactName               256A   const
      *
      /EJECT
      *
      /free
 
         Exec SQL
              Delete from BFTB_GROUPPERMMAP
               where BFPERMISSIONID in
               ( select BFPERMISSIONID
                   from BFTB_RESOURCEPERM
                  where
                        BFRESOURCEID = :ArtefactName);
 
         Exec SQL
              Delete from BFTB_PERMISSION
               where BFIDPK in
               ( select BFPERMISSIONID
                   from BFTB_RESOURCEPERM
                  where
                        BFRESOURCEID = :ArtefactName);
 
         Exec SQL
              Delete from BFTB_RESOURCEPERM
               where
                     BFRESOURCEID = :ArtefactName;
 
         Exec SQL
              Delete from BFTB_RESOURCE
               where
                     BFARTEFACTID = :ArtefactName;
 
       //  End Procedure
 
               RetCode = 1;
               *INLR = '1';
               return RetCode;
 
      /end-free
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
